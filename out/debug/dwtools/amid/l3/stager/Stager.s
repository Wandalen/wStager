( function _Stager_s_( ) {

'use strict';

/**
  @module Tools/mid/Stager - Class to organize states of an object.
*/

/**
 * @file Stager.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wBitmask' );
  _.include( 'wConsequence' );

}

//

/**
 * @classdesc Class to organize stages of an object and its states.

Stager has a reference on an object, list of names of stages, list of names of consequences.
Stager has such predefined combination of states:
Skipping - skip the stage.
Pausing - pause on this stage till resuming.
Begun - the processing of the stage was initiated.
Ended - the processing of the stage was finished, possibly it was skipped.
Errored - fault state.
Performed - the processing of the stage was performed, false if it was skipped.

 * @class wStager
 * @memberof module:Tools/mid/Stager
*/

let _ = wTools;
let Parent = null;
let Self = function wStager( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Stager';

// --
// inter
// --

function init( o )
{
  let stager = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( stager );
  Object.preventExtensions( stager );

  stager.consequence.take( null );

  if( o )
  stager.copy( o );

  stager.onPerform = _.scalarToVector( stager.onPerform, stager.stageNames.length );
  stager.onBegin = _.scalarToVector( stager.onBegin, stager.stageNames.length );
  stager.onEnd = _.scalarToVector( stager.onEnd, stager.stageNames.length );

  _.assert( _.arrayIs( stager.stageNames ) );
  _.assert( _.arrayIs( stager.consequenceNames ) );
  _.assert( stager.stageNames.length === stager.consequenceNames.length );
  _.assert( stager.stageNames.length === stager.onPerform.length );
  _.assert( _.strsAreAll( stager.stageNames ) );
  _.assert( _.strsAreAll( stager.consequenceNames ) );
  _.assert( _.objectIs( stager.object ) );

  if( !stager.stateMaskFields )
  stager.stateMaskFields =
  [
    { skipping : false },
    { pausing : false },
    // { begun : false },
    // { ended : false },
    { errored : false },
    { performed : false },
  ];

  if( !stager.stateMask )
  stager.stateMask = _.Bitmask
  ({
    defaultFieldsArray : stager.stateMaskFields
  });

  stager.currentStage = stager.stageNames[ 0 ];
  stager.currentPhase = 0;

  // Object.freeze( stager );
}

//

/**
 * @summary Cancel stage resting `errored`, `ended`, `performed` states and making possible to rerun it.
 * @param {String} stageName Name of stage.
 * @funciton stageCancel
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageCancel( stageName )
{
  let stager = this;
  let object = stager.object;
  let stageIndex = stager.stageIndexOf( stageName );
  let consequence = object[ stager.consequenceNames[ stageIndex ] ];
  stageName = stager.stageNameOf( stageIndex );

  _.assert( arguments.length === 1 );

  let state = stager.stageState( stageIndex );

  if( state.ended )
  consequence.finallyGive( 1 );

  state.ended = false;
  state.errored = false;
  state.performed = false;
  stager.stageState( stageIndex, state );

  return stager.consequence;
}

//

/**
 * @descriptionNeeded
 * @param {String} stageName Name of stage.
 * @funciton stageReset
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageReset( stageName, allAfter )
{
  let stager = this;
  let object = stager.object;
  let stageIndex = stager.stageIndexOf( stageName );
  let consequence = object[ stager.consequenceNames[ stageIndex ] ];
  stageName = stager.stageNameOf( stageIndex );

  _.assert( arguments.length === 2 );

  stager.consequence.then( ( arg ) =>
  {

    for( let s = stageIndex+1 ; s < stager.stageNames.length ; s++ )
    {
      let consequence = stager.object[ stager.consequenceNames[ s ] ];

      consequence.resourcesCancel(); // xxx : replace
      // if( state.ended )
      // consequence.finallyGive( 1 );

      let state = stager.stageState( s );
      if( allAfter || s === stager.stageNames.length-1 || state.errored )
      {
        // state.ended = false;
        state.errored = false;
        state.performed = false;
        stager.stageState( s, state );
      }
    }

    consequence.resourcesCancel(); // xxx : replace
    // if( state.ended )
    // consequence.finallyGive( 1 );

    let state = stager.stageState( stageIndex );
    state.skipping = false;
    state.pausing = false;
    // state.ended = false;
    state.errored = false;
    state.performed = false;
    stager.stageState( stageIndex, state );

    stager.currentStage = stageName;
    stager.currentPhase = 0;

    // stager.tick();

    return arg;
  });

  return consequence;
}

//

/**
 * @summary Put stage in `errored` state.
 * @param {String} stageName Name of stage.
 * @param {String} error Error message.
 * @funciton stageError
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageError( stageName, error )
{
  let stager = this;
  let object = stager.object;
  let stageIndex = stager.stageIndexOf( stageName );
  let consequence = object[ stager.consequenceNames[ stageIndex ] ];

  error = _.err( error );

  let state2 = stager.stageState( stageName );
  state2.performed = 0;
  state2.errored = true;
  // state2.begun = false;
  // state2.ended = true;
  stager.stageState( stageName, state2 );

  consequence.take( error, undefined );

  return error;
}

//

/**
 * @summary Returns wConsequence instance associataed with the stage. Takes name of stage `stageName` and `offset`.
 * @param {String} stageName Name of stage.
 * @param {Number} offset Offset of stage.
 * @funciton stageConsequence
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageConsequence( stageName, offset )
{
  let stager = this;
  let object = stager.object;
  let stageIndex = stager.stageIndexOf( stageName, offset );
  let consequence = object[ stager.consequenceNames[ stageIndex ] ];

  _.assert( _.consequenceIs( consequence ) );

  return consequence;
}

//

/**
 * @summary Returns stage index. Takes stage name `stageName` and stage `offset`.
 * @param {String} stageName Name of stage.
 * @param {Number} offset Offset of stage.
 * @funciton stageIndexOf
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageIndexOf( stageName, offset )
{
  let stager = this;
  let stageIndex = stageName;
  offset = offset || 0;

  if( _.strIs( stageIndex ) )
  stageIndex = stager.stageNames.indexOf( stageIndex )

  _.assert( _.numberIs( stageIndex ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  stageIndex += offset;

  _.assert
  (
    0 <= stageIndex && stageIndex < stager.stageNames.length,
    () => 'Stage ' + stageName + ' with offset ' + offset + ' does not exist'
  );

  return stageIndex;
}

//

/**
 * @summary Return name of stage for index `stageIndex`.
 * @param {Number} stageIndex Index of stage.
 * @funciton stageNameOf
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageNameOf( stageIndex )
{
  let stager = this;
  let stagaName = stageIndex;

  if( _.numberIs( stagaName ) )
  stagaName = stager.stageNames[ stagaName ];

  _.assert( _.strIs( stagaName ), () => 'Cant find stage name for stage index ' + stageIndex );
  _.assert( arguments.length === 1 );

  return stagaName;
}

//

/**
 * @summary Set or get specific state of all stages.
 * @param {String} stageName Name of stage.
 * @funciton stagesState
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stagesState( stateName, value )
{
  let stager = this;
  let object = stager.object;
  let result = Object.create( null );

  _.assert( arguments.length === 1 || arguments.length === 2 );

  for( let stageIndex = 0 ; stageIndex < stager.stageNames.length ; stageIndex++ )
  {
    let stageName = stager.stageNames[ stageIndex ];
    let state = stager.stageState( stageIndex );

    _.assert( _.boolIs( state[ stateName ] ) );

    if( value !== undefined )
    state[ stateName ] = !!value;
    result[ stageName ] = state[ stateName ];

    stager.stageState( stageIndex, state );
  }

  return result;
}

//

/**
 * @summary Returns info about stages.
 * @funciton infoExport
 * @memberof module:Tools/mid/Stager.wStager#
*/

function infoExport()
{
  let stager = this;
  let result = '';

  for( let stageIndex = 0 ; stageIndex < stager.stageNames.length ; stageIndex++ )
  {
    let stageName = stager.stageNames[ stageIndex ];
    let state = stager.stageState( stageIndex );
    let consequence = stager.object[ stager.consequenceNames[ stageIndex ] ];
    let failStr = consequence.errorsCount() ? ( ' - ' + 'fail' ) : '';
    let conStr = consequence.infoExport({ verbosity : 1 });
    let stateStr = '';
    for( let s in state )
    stateStr += s[ 0 ] + s[ 1 ] + ':' + state[ s ] + ' ';
    result += stageName + ' : ' + stateStr + '- ' + conStr + failStr + '\n';
  }

  return result;
}

//

/**
 * @descriptionNeeded
 * @param {String} stageName Name of stage.
 * @param {Number} number Number of stage.
 * @funciton stageState
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageState( stage, state )
{
  let stager = this;
  let stageIndex = stager.stageIndexOf( stage );
  let currenStageIndex = stager.stageIndexOf( stager.currentStage );
  let begun = currenStageIndex > stageIndex || ( currenStageIndex == stageIndex && stager.currentPhase === 1 );
  let ended = currenStageIndex > stageIndex || ( currenStageIndex == stageIndex && stager.currentPhase >= 2 );

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( state === undefined )
  {
    state = stager.object[ stager.stageNames[ stageIndex ] ];
    state = stager.stateToMap( state );
    state.begun = begun;
    state.ended = ended;
  }
  else
  {
    _.assert( state.begun === begun );
    _.assert( state.ended === ended );
    _.assert( !Object.isFrozen( stager.object ), () => 'Object is frozen, cant modify it : ' + _.toStrShort( stager.object ) );
    let state2 = _.mapExtend( null, state );
    delete state2.begun;
    delete state2.ended;
    stager.object[ stager.stageNames[ stageIndex ] ] = stager.stateFromMap( state2 );
  }

  return state;
}


//

function stageStateSpecific_functor( stateName )
{

  return function stageStateSpecific( stage, value )
  {
    let stager = this;

    _.assert( arguments.length === 1 || arguments.length === 2 );

    let state = stager.stageState( stage );

    if( value !== undefined )
    {
      _.assert( _.boolIs( state[ stateName ] ) );
      state[ stateName ] = !!value;
      stager.stageState( stage, state );
    }

    _.assert( _.boolIs( state[ stateName ] ) );
    return state[ stateName ];
  }

}

//

function stateToMap( src )
{
  let stager = this;
  return stager.stateMask.wordToMap( src );
}

//

function stateFromMap( src )
{
  let stager = this;
  return stager.stateMask.mapToWord( src );
}

//

function isValid()
{
  let stager = this;

  for( let stageIndex = 0 ; stageIndex < stager.stageNames.length ; stageIndex++ )
  {
    let state = stager.stageState( stageIndex );
    if( state.errored )
    return false;
  }

  return true;
}

//

function tick()
{
  let stager = this;
  let currenStageIndex = stager.stageIndexOf( stager.currentStage );

  if( Object.isFrozen( stager.object ) )
  return stager.object[ stager.consequenceNames[ stager.consequenceNames.length - 1 ] ];

  /* if begin a stage then return */

  if( stager.currentPhase === 1 )
  {
    _.assert( stager.running > 0 );
    stager.object[ stager.consequenceNames[ currenStageIndex ] ];
  }

  stager.running += 1;
  if( stager.running === 1 )
  {
    // if( stager.verbosity )
    // logger.log( 'stager.running begin' );
    // statusChange( 'running', 'begin', '' );
    statusChange( `${stager.currentStage}.ticking`, 'begin', '' );
  }

  debugger;

  // for( let stageIndex = 0 ; stageIndex < stager.stageNames.length ; stageIndex++ )
  for( let stageIndex = currenStageIndex ; stageIndex < stager.stageNames.length ; stageIndex++ )
  {

    _.assert( stager.currentPhase === 0 || stager.currentPhase === 3 );

    if( stager.currentPhase === 3 )
    {
      if( currenStageIndex === stager.stageNames.length - 1 )
      stager.object[ stager.consequenceNames[ currenStageIndex ] ];
      stager.currentStage = stager.stageNames[ currenStageIndex+1 ];
      stager.currentPhase = 0;
    }

    let stageName = stager.stageNames[ stageIndex ];
    let state = stager.stageState( stageIndex );
    let consequence = stager.object[ stager.consequenceNames[ stageIndex ] ];
    let onPerform = stager.onPerform[ stageIndex ];
    let onBegin = stager.onBegin[ stageIndex ];
    let onEnd = stager.onEnd[ stageIndex ];

    _.assert( !consequence.resourcesCount() || state.ended );
    _.assert( !state.ended );

    if( !state.ended )
    {

      _.assert( stager.stageIndexOf( stager.currentStage ) === stageIndex );

      if( state.begun || state.pausing )
      {
        end();
        return consequence;
      }

      if( state.errored )
      {
        _.assert( 0, 'not tested' );
      }

      if( !onPerform || state.skipping || state.performed )
      onPerform = function() { return null }

      _.assert( stager.currentPhase === 0 );
      stager.currentPhase = 1;
      // state.begun = true;
      // stager.stageState( stageIndex, state );

      let prevConsequence = stager.object[ stager.consequenceNames[ stageIndex-1 ] ]
      if( !prevConsequence )
      prevConsequence = new _.Consequence().take( null );

      return routineRun( onBegin, onPerform, onEnd, stageName, state, prevConsequence, consequence );
    }

  }

  return end();

  /* */

  function end()
  {
    stager.running -= 1;
    if( stager.running === 0 )
    {
      // if( stager.verbosity )
      // logger.log( 'stager.running end' );
      // statusChange( stageName, 'running', 'end' );
      statusChange( `${stager.currentStage}.ticking`, 'end', '' );
    }
    return stager.object[ stager.consequenceNames[ stager.consequenceNames.length - 1 ] ];
  }

  /* */

  function statusChange( stageName, stateName, status )
  {
    let info = `stage:${stageName}.${stateName} ${stager.object.absoluteName} running:${stager.running} status:${status}`;
    if( stager.verbosity )
    logger.log( info );
    stager.currentStatus = info;

    if( _.strHas( info, 'stage:formed.before module::sub running:1 status:' ) )
    debugger;

  }

  /* */

  function routineRun( onBegin, onPerform, onEnd, stageName, state, prevConsequence, consequence )
  {

    // stager.running += 1;

    statusChange( stageName, 'before', '' );

    prevConsequence = prevConsequence.split();

    prevConsequence.andTake( stager.consequence );

    prevConsequence.then( ( arg ) =>
    {
      statusChange( stageName, 'begin', '' );
      if( onBegin === null )
      return arg;
      try
      {
        return onBegin.call( stager.object );
      }
      catch( err )
      {
        statusChange( stageName, 'begin', 'error' );
        err = _.err( 'Error on begin of stage', stageName, '\n', err );
        throw err;
      }
    });

    prevConsequence.then( ( arg ) =>
    {
      statusChange( stageName, 'perform', '' );
      try
      {
        return onPerform.call( stager.object );
      }
      catch( err )
      {
        statusChange( stageName, 'perform', 'error' );
        err = _.err( 'Error on perform of stage', stageName, '\n', err );
        throw err;
      }
    });

    prevConsequence.finally( ( err, arg ) =>
    {

      if( err )
      {
        statusChange( stageName, 'after1', 'error' );
      }
      else if( state.skipping )
      {
        statusChange( stageName, 'after1', 'skip' );
      }
      else
      {
        statusChange( stageName, 'after1', '' );
      }

      let state2 = stager.stageState( stageName );
      state2.performed = ( !state.skipping || state.performed ) && !err;
      state2.errored = !!err;
      // state2.begun = false;
      // state2.ended = true;
      stager.stageState( stageName, state2 );

      _.assert( stager.currentPhase === 1 );
      stager.currentPhase = 2;

      consequence.take( err, arg );

      return arg || null;
    });

    prevConsequence.then( ( arg ) =>
    {
      statusChange( stageName, 'end', '' );
      if( onEnd === null )
      return arg;
      try
      {
        return onEnd.call( stager.object );
      }
      catch( err )
      {
        statusChange( stageName, 'end', 'error' );
        err = _.err( 'Error on end of stage', stageName, '\n', err );
        throw err;
      }
    });

    prevConsequence.finally( ( err, arg ) =>
    {

      if( err )
      {
        debugger;
        statusChange( stageName, 'after2', 'error' );
        let state2 = stager.stageState( stageName );
        state2.performed = 0;
        state2.errored = 1;
        stager.stageState( stageName, state2 );
      }
      else
      {
        statusChange( stageName, 'after2', '' );
      }

      _.assert( stager.currentPhase === 2 );
      stager.currentPhase = 3;
      // stager.running -= 1;

      end();
      stager.consequence.take( arg || null );
      stager.tick();

      if( err )
      throw err;
      return arg;
    });

    return consequence;
  }

}

// --
// relations
// --

let Composes =
{
  stageNames : null,
  consequenceNames : null,
  verbosity : 0,
  stateMaskFields : null,
  onPerform : null,
  onBegin : null,
  onEnd : null,
  consequence : _.define.instanceOf( _.Consequence ),
}

let Aggregates =
{
}

let Associates =
{
  object : null,
}

let Restricts =
{
  currentStatus : null,
  currentStage : null,
  currentPhase : 0,
  stateMask : null,
  running : 0,
}

let Statics =
{
}

let Forbids =
{
  finals : 'finals',
}

let Accessors =
{
}

// --
// declare
// --

let Proto =
{

  // inter

  init,

  stageCancel,
  stageReset,
  stageError,
  stageConsequence,
  stageIndexOf,
  stageNameOf,
  stagesState,

  stageState,
  stageStateSkipping : stageStateSpecific_functor( 'skipping' ),
  stageStatePausing : stageStateSpecific_functor( 'pausing' ),
  stageStateBegun : stageStateSpecific_functor( 'begun' ),
  stageStateEnded : stageStateSpecific_functor( 'ended' ),
  stageStateErrored : stageStateSpecific_functor( 'errored' ),
  stageStatePerformed : stageStateSpecific_functor( 'performed' ),

  stateToMap,
  stateFromMap,

  isValid,
  tick,

  infoExport,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_[ Self.shortName ] = Self;
if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

})();
