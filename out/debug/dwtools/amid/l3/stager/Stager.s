( function _Stager_s_( ) {

'use strict';

/**
 * Class to organize states of an object.
  @module Tools/mid/Stager
*/

/**
 * @file Stager.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../Tools.s' );

  _.include( 'wCopyable' );

}

//

/**
 * @classdesc Class to organize states of an object.
 * @class wStager
 * @memberof module:Tools/mid/Stager
*/

let _ = wTools;
let Parent = null;
let Self = function wStager( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Stager';

// --
// inter
// --

function init( o )
{
  let stager = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.instanceInit( stager );
  Object.preventExtensions( stager );

  if( o )
  stager.copy( o );

  _.assert( _.arrayIs( stager.stageNames ) );
  _.assert( _.arrayIs( stager.consequenceNames ) );
  _.assert( _.arrayIs( stager.finals ) );
  _.assert( stager.stageNames.length === stager.consequenceNames.length );
  _.assert( stager.stageNames.length === stager.finals.length );
  _.assert( _.strsAreAll( stager.stageNames ) );
  _.assert( _.strsAreAll( stager.consequenceNames ) );
  _.assert( _.numbersAre( stager.finals ) );
  _.assert( _.objectIs( stager.object ) );

  Object.freeze( stager );
}

//

/**
 * @descriptionNeeded
 * @param {String} stageName Name of stage.
 * @param {Number} number Number of stage.
 * @funciton stageState
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageState( stageName, number )
{
  let stager = this;
  let object = stager.object;
  let stageIndex = stager.stageIndexOf( stageName );
  stageName = stager.stageNameOf( stageIndex );

  if( arguments.length === 1 )
  return object[ stager.stageNames[ stageIndex ] ];

  let l = stager.stageNames.length;
  let consequence = object[ stager.consequenceNames[ stageIndex ] ];
  let isFinal = number === stager.finals[ stageIndex ];

  // if( Config.debug )
  // for( let s = 0 ; s < stageIndex ; s++ )
  // _.assert( object[ stager.stageNames[ s ] ] > 0, () => 'For ' + object.nickName + ' states preceding ' + _.strQuote( stageName ) + ' should be greater than zero, but ' + _.strQuote( stager.stageNames[ s ] ) + ' is not' );

  if( Config.debug )
  for( let s = stageIndex+1 ; s < l ; s++ )
  _.assert( object[ stager.stageNames[ s ] ] <= 1, () => 'States following ' + _.strQuote( stageName ) + ' should be zero or one, but ' + _.strQuote( stager.stageNames[ s ] ) + ' is ' + object[ stager.stageNames[ s ] ] );

  _.assert( arguments.length === 2 );
  _.assert( _.consequenceIs( consequence ) );
  _.assert( stageIndex >= 0, () => 'Unknown stage ' + _.strQuote( stageName ) );
  _.assert( _.numberIs( number ) && number <= stager.finals[ stageIndex ], () => 'Stage ' + _.strQuote( stageName ) + ' should be in range ' + _.rangeToStr([ 0, stager.finals[ stageIndex ] ]) );
  _.assert( object[ stageName ]+1 === number, () => 'Stage ' + _.strQuote( stageName ) + ' has value ' + object[ stageName ] + ' so the next value should be ' + ( object[ stageName ]+1 ) + ' attempt to set ' + number );
  _.assert( !consequence.resourcesCount(), () => 'Consequences ' + _.strQuote( stager.consequenceNames[ stageIndex ] ) + ' of the current stage ' + _.strQuote( stageName ) + ' should have no resource' );

  object[ stageName ] = number;

  if( stager.verbosity )
  console.log( ' s', object.nickName, stageName, number );

  if( isFinal )
  consequence.take( null );

  return isFinal;
}

//

/**
 * @descriptionNeeded
 * @param {String} stageName Name of stage.
 * @funciton stageCancel
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageCancel( stageName )
{
  let stager = this;
  let object = stager.object;
  let stageIndex = stager.stageIndexOf( stageName );
  stageName = stager.stageNameOf( stageIndex );

  _.assert( arguments.length === 1 );

  let l = stager.stageNames.length;
  let consequence = object[ stager.consequenceNames[ stageIndex ] ];
  let finalConsequence = object[ stager.consequenceNames[ stager.consequenceNames.length - 1 ] ];

  if( consequence.resourcesCount() )
  {
    _.assert( stageIndex === stager.consequenceNames.length-2, 'Implemented only for penultimate stage' );
    consequence.cancel();
    return finalConsequence.splitGive();
    // let cons = [];
    // for( let s = stageIndex+1 ; s < l ; s++ )
    // {
    //   cons.push( object[ stager.consequenceNames[ s ] ] );
    // }
    // debugger;
    // return _.Consequence.AndTake( cons );
  }

  return new _.Consequence().take( null );

  // // if( Config.debug )
  // // for( let s = 0 ; s < stageIndex ; s++ )
  // // _.assert( object[ stager.stageNames[ s ] ] > 0, () => 'For ' + object.nickName + ' states preceding ' + _.strQuote( stageName ) + ' should be greater than zero, but ' + _.strQuote( stager.stageNames[ s ] ) + ' is not' );
  //
  // if( Config.debug )
  // for( let s = stageIndex+1 ; s < l ; s++ )
  // _.assert( object[ stager.stageNames[ s ] ] <= 1, () => 'States following ' + _.strQuote( stageName ) + ' should be zero or one, but ' + _.strQuote( stager.stageNames[ s ] ) + ' is ' + object[ stager.stageNames[ s ] ] );
  //
  // _.assert( arguments.length === 2 );
  // _.assert( _.consequenceIs( consequence ) );
  // _.assert( stageIndex >= 0, () => 'Unknown stage ' + _.strQuote( stageName ) );
  // _.assert( _.numberIs( number ) && number <= stager.finals[ stageIndex ], () => 'Stage ' + _.strQuote( stageName ) + ' should be in range ' + _.rangeToStr([ 0, stager.finals[ stageIndex ] ]) );
  // _.assert( object[ stageName ]+1 === number, () => 'Stage ' + _.strQuote( stageName ) + ' has value ' + object[ stageName ] + ' so the next value should be ' + ( object[ stageName ]+1 ) + ' attempt to set ' + number );
  // _.assert( !consequence.resourcesCount(), () => 'Consequences ' + _.strQuote( stager.consequenceNames[ stageIndex ] ) + ' of the current stage ' + _.strQuote( stageName ) + ' should have no resource' );
  //
  // object[ stageName ] = number;
  //
  // if( stager.verbosity )
  // console.log( ' s', object.nickName, stageName, number );
  //
  // if( isFinal )
  // consequence.take( null );
  //
  // return isFinal;
}

//

/**
 * @descriptionNeeded
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

  if( stager.verbosity  )
  console.log( ' !s', object.nickName, stageName, 'failed' );
  consequence.error( error );

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
 * @summary Skips stage with name `stageName`.
 * @param {String} stageName Name of stage.
 * @funciton stageSkip
 * @memberof module:Tools/mid/Stager.wStager#
*/

function stageSkip( stageName )
{
  let stager = this;
  let object = stager.object;
  let stageIndex = stager.stageIndexOf( stageName );
  let consequence = object[ stager.consequenceNames[ stageIndex ] ];
  let final = stager.finals[ stageIndex ];

  _.assert( arguments.length === 1 );

  if( stager.stageState( stageIndex ) > 0 )
  return stager.stageConsequence( stageIndex );

  // stager.stageState( stageIndex, 1 ); // yyy

  let result = stager.stageConsequence( stageIndex, -1 ).split()
  .finally( ( err, arg ) =>
  {
    if( err )
    throw stager.stageError( stageIndex, err );
    _.assert( !consequence.resourcesCount() );
    consequence.take( null );
    // else // yyy
    // for( let i = 2 ; i <= final ; i++ )
    // stager.stageState( stageIndex, i );
    return arg;
  });

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
  for( let n = 0 ; n < stager.stageNames.length ; n++ )
  {
    let stageName = stager.stageNames[ n ];
    let value = stager.object[ stageName ];
    let consequence = stager.object[ stager.consequenceNames[ n ] ];
    let final = stager.finals[ n ];
    let failStr = consequence.errorsCount() ? ( ' - ' + 'fail' ) : '';
    let conStr = consequence.infoExport({ detailing : 1 });
    let stateStr = value + ' / ' + final;
    result += stageName + ' : ' + stateStr + ' - ' + conStr + failStr + '\n';
  }
  return result;
}

// --
// relations
// --

let Composes =
{
  stageNames : null,
  consequenceNames : null,
  finals : null,
  verbosity : 0,
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
}

let Statics =
{
}

let Forbids =
{
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

  stageState,
  stageCancel,
  stageError,
  stageConsequence,
  stageIndexOf,
  stageNameOf,
  stageSkip,

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
