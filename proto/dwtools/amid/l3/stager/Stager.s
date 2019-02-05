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

}

//

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

function stage( stageName, number )
{
  let stager = this;
  let object = stager.object;
  let l = stager.stageNames.length;
  let stage = stager.stageNames.indexOf( stageName );
  let consequence = object[ stager.consequenceNames[ stage ] ];
  let isFinal = number === stager.finals[ stage ];

  if( Config.debug )
  for( let s = 0 ; s < stage ; s++ )
  {
    _.assert( object[ stager.stageNames[ s ] ] > 0, () => 'For ' + object.nickName + ' states preceding ' + _.strQuote( stageName ) + ' should be greater than zero, but ' + _.strQuote( stager.stageNames[ s ] ) + ' is not' );
  }

  if( Config.debug )
  for( let s = stage+1 ; s < l ; s++ )
  {
    _.assert( object[ stager.stageNames[ s ] ] <= 1, () => 'States following ' + _.strQuote( stageName ) + ' should be zero or one, but ' + _.strQuote( stager.stageNames[ s ] ) + ' is ' + object[ stager.stageNames[ s ] ] );
  }

  _.assert( arguments.length === 2 );
  _.assert( _.consequenceIs( consequence ) );
  _.assert( stage >= 0, () => 'Unknown stage ' + _.strQuote( stageName ) );
  _.assert( _.numberIs( number ) && number <= stager.finals[ stage ], () => 'Stage ' + _.strQuote( stageName ) + ' should be in range ' + _.rangeToStr([ 0, stager.finals[ stage ] ]) );
  _.assert( object[ stageName ]+1 === number, () => 'Stage ' + _.strQuote( stageName ) + ' has value ' + object[ stageName ] + ' so the next value should be ' + ( object[ stageName ]+1 ) + ' attempt to set ' + number );
  _.assert( !consequence.resourcesCount(), () => 'Consequences ' + _.strQuote( stager.consequenceNames[ stage ] ) + ' of the current stage ' + _.strQuote( stageName ) + ' should have no resource' );

  object[ stageName ] = number;

  if( stager.verbosity )
  console.log( ' s', object.nickName, stageName, number );

  // if( stageName === 'resourcesFormed' )
  // console.log( ' s', object.nickName, stageName, number );

  // if( isFinal )
  // consequence.takeSoon( null );

  if( isFinal )
  consequence.take( null );

  return isFinal;
}

//

function stageError( stageName, error )
{
  let stager = this;
  let object = stager.object;
  let stage = stager.stageNames.indexOf( stageName );
  let consequence = object[ stager.consequenceNames[ stage ] ];

  // debugger;

  if( stager.verbosity  )
  console.log( ' !s', object.nickName, stageName, 'failed' );
  consequence.error( error );

/*
  module.stager.stageError( submodulesFormed );
  if( will.verbosity && will.verboseStaging )
  console.log( ' !s', module.nickName, 'submodulesFormed', 'failed' );
  module.submodulesFormReady.error( err );
*/

  return error;
}

//

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
  stage,
  stageError,
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
