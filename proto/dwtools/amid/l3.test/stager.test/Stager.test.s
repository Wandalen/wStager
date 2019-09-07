( function _WillInternals_test_s_( ) {

'use strict';

/*
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../Tools.s' );

  _.include( 'wTesting' );;

  require( '../../l3/stager/Stager.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// tests
// --

function trivial( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;

  let object = Object.create( null );
  object.stage1 = 0;
  object.stage2 = 0;
  object.stage3 = 0;
  object.ready1 = new _.Consequence();
  object.ready2 = new _.Consequence();
  object.ready3 = new _.Consequence();
  object.perform1 = perform1;
  object.perform2 = perform2;
  object.perform3 = perform3;

  let stager = new _.Stager
  ({
    object : object,
    verbosity : 5,
    stageNames :        [ 'stage1', 'stage2', 'stage3' ],
    consequenceNames :  [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  var exp =
  {
  }
  var got = stager.stagesState( 'stage1' );
  test.identical( got, expected );

  stager.tick();

  return _.timeOut( 1000, () =>
  {

    test.case = 'were performers called'
    test.identical( perform1End, 1 );
    test.identical( perform2End, 1 );
    test.identical( perform3End, 1 );

  });

  /* - */

  function peform1()
  {
    perform1End = 1;
  }

  function peform2()
  {
    return _.timeOut( 100, () =>
    {
      perform2End = 1;
    });
  }

  function peform3()
  {
    perform3End = 1;
  }

}

// --
// define class
// --

var Self =
{

  name : 'Tools/amid/Stager',
  silencing : 1,

  tests :
  {

    trivial,

  }

}

// --
// export
// --

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
