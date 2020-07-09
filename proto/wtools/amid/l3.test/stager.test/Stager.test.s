( function _Stager_test_s_( ) {

'use strict';

/*
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../wtools/Tools.s' );

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  test.description = 'state of stage1';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage1' );
  test.identical( got, exp );

  test.description = 'state of stage2';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage2' );
  test.identical( got, exp );

  test.description = 'state of stage3';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage3' );
  test.identical( got, exp );

  stager.tick();

  return _.time.out( 1000, end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : false
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : false
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : false
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    perform3End += 1;
    return null;
  }

  function end()
  {

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

  }

} /* end of function trivial */

//

function make( test )
{
  let self = this;

  /* - */

  test.case = 'full';
  var object = Object.create( null );
  object.stage1 = 0;
  object.ready1 = new _.Consequence();
  var stager = _.Stager
  ({
    object : object,
    verbosity : 5,
    stageNames :        [ 'stage1' ],
    consequences :      [ object.ready1 ],
    onPerform :         [ perform1 ],
    onBegin :           [ begin1 ],
    onEnd :             [ end1 ],
  });
  test.is( stager instanceof _.Stager );

  /* */

  test.case = 'minimal';
  var object = Object.create( null );
  object.stage1 = 0;
  object.ready1 = new _.Consequence();
  var stager = _.Stager
  ({
    object : object,
    verbosity : 5,
    stageNames :        [ 'stage1' ],
    consequences :      [ object.ready1 ],
  });
  test.is( stager instanceof _.Stager );

  /* - */

  if( !Config.debug )
  return;

  /* - */

  test.shouldThrowErrorSync( () =>
  {
    test.case = 'bad begin';
    var object = Object.create( null );
    object.stage1 = 0;
    object.ready1 = new _.Consequence();
    var stager = _.Stager
    ({
      object : object,
      verbosity : 5,
      stageNames :        [ 'stage1' ],
      consequences :      [ object.ready1 ],
      onPerform :         [ perform1 ],
      onBegin :           [ 1 ],
      onEnd :             [ end1 ],
    });
    test.is( stager instanceof _.Stager );
  });

  test.shouldThrowErrorSync( () =>
  {
    test.case = 'bad perform';
    var object = Object.create( null );
    object.stage1 = 0;
    object.ready1 = new _.Consequence();
    var stager = _.Stager
    ({
      object : object,
      verbosity : 5,
      stageNames :        [ 'stage1' ],
      consequences :      [ object.ready1 ],
      onPerform :         [ 1 ],
      onBegin :           [ begin1 ],
      onEnd :             [ end1 ],
    });
    test.is( stager instanceof _.Stager );
  });

  test.shouldThrowErrorSync( () =>
  {
    test.case = 'bad end';
    var object = Object.create( null );
    object.stage1 = 0;
    object.ready1 = new _.Consequence();
    var stager = _.Stager
    ({
      object : object,
      verbosity : 5,
      stageNames :        [ 'stage1' ],
      consequences :      [ object.ready1 ],
      onPerform :         [ perform1 ],
      onBegin :           [ begin1 ],
      onEnd :             [ 1 ],
    });
    test.is( stager instanceof _.Stager );
  });

  test.shouldThrowErrorSync( () =>
  {
    test.case = 'bad consequence';
    var object = Object.create( null );
    object.stage1 = 0;
    object.stage2 = 'x';
    object.ready1 = new _.Consequence();
    var stager = _.Stager
    ({
      object : object,
      verbosity : 5,
      stageNames :        [ 'stage1' ],
      consequences :      [ 1 ],
      onPerform :         [ perform1 ],
      onBegin :           [ begin1 ],
      onEnd :             [ end1 ],
    });
    test.is( stager instanceof _.Stager );
  });

  test.shouldThrowErrorSync( () =>
  {
    test.case = 'bad stage - string';
    var object = Object.create( null );
    object.stage1 = 0;
    object.stage2 = 'x';
    object.ready1 = new _.Consequence();
    var stager = _.Stager
    ({
      object : object,
      verbosity : 5,
      stageNames :        [ 'stage2' ],
      consequences :      [ object.ready1 ],
      onPerform :         [ perform1 ],
      onBegin :           [ begin1 ],
      onEnd :             [ end1 ],
    });
    test.is( stager instanceof _.Stager );
  });

  test.shouldThrowErrorSync( () =>
  {
    test.case = 'bad stage - null';
    var object = Object.create( null );
    object.stage1 = 0;
    object.stage2 = null;
    object.ready1 = new _.Consequence();
    var stager = _.Stager
    ({
      object : object,
      verbosity : 5,
      stageNames :        [ 'stage2' ],
      consequences :      [ object.ready1 ],
      onPerform :         [ perform1 ],
      onBegin :           [ begin1 ],
      onEnd :             [ end1 ],
    });
    test.is( stager instanceof _.Stager );
  });

  test.shouldThrowErrorSync( () =>
  {
    test.case = 'bad stage - undefined';
    var object = Object.create( null );
    object.stage1 = 0;
    object.stage2 = undefined;
    object.ready1 = new _.Consequence();
    var stager = _.Stager
    ({
      object : object,
      verbosity : 5,
      stageNames :        [ 'stage2' ],
      consequences :      [ object.ready1 ],
      onPerform :         [ perform1 ],
      onBegin :           [ begin1 ],
      onEnd :             [ end1 ],
    });
    test.is( stager instanceof _.Stager );
  });

  /* - */

  function begin1()
  {
    return null;
  }

  function perform1()
  {
    return null;
  }

  function end1()
  {
    return null;
  }

} /* end of function make */

//

function byNames( test )
{
  let self = this;
  let begin1End = 0;
  let begin2End = 0;
  let begin3End = 0;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let end1End = 0;
  let end2End = 0;
  let end3End = 0;

  let object = Object.create( null );
  object.stage1 = 0;
  object.stage2 = 0;
  object.stage3 = 0;
  object.ready1 = new _.Consequence();
  object.ready2 = new _.Consequence();
  object.ready3 = new _.Consequence();
  object.begin1 = begin1;
  object.begin2 = begin2;
  object.begin3 = begin3;
  object.perform1 = perform1;
  object.perform2 = perform2;
  object.perform3 = perform3;
  object.end1 = end1;
  object.end2 = end2;
  object.end3 = end3;

  let stager = new _.Stager
  ({
    object : object,
    verbosity : 5,
    stageNames :        [ 'stage1', 'stage2', 'stage3' ],
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ 'perform1', 'perform2', 'perform3' ],
    onBegin :           [ 'begin1', 'begin2', 'begin3' ],
    onEnd :             [ 'end1', 'end2', 'end3' ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  test.description = 'state of stage1';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage1' );
  test.identical( got, exp );

  test.description = 'state of stage2';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage2' );
  test.identical( got, exp );

  test.description = 'state of stage3';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage3' );
  test.identical( got, exp );

  stager.tick();

  return _.time.out( 1000, end );

  /* - */

  function begin1()
  {
    begin1End += 1;

    test.description = 'begin1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    begin1End += 1;
    return null;
  }

  function begin2()
  {
    begin2End += 1;

    test.description = 'begin2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'begin2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      begin2End += 1;
    });
  }

  function begin3()
  {
    begin3End += 1;

    test.description = 'begin3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    begin3End += 1;
    return null;
  }

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function end1()
  {
    end1End += 1;

    test.description = 'end1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 2 );

    end1End += 1;
    return null;
  }

  function end2()
  {
    end2End += 1;

    test.description = 'end2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 2 );

    return _.time.out( 50, () =>
    {
      test.description = 'end2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 2 );
      end2End += 1;
    });
  }

  function end3()
  {
    end3End += 1;

    test.description = 'end3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 2 );

    end3End += 1;
    return null;
  }

  function end()
  {

    test.description = 'were callbacks called';
    test.identical( begin1End, 2 );
    test.identical( begin2End, 2 );
    test.identical( begin3End, 2 );
    test.identical( perform1End, 2 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 2 );
    test.identical( end1End, 2 );
    test.identical( end2End, 2 );
    test.identical( end3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

  }

} /* end of function byNames */

//

function byVals( test )
{
  let self = this;
  let begin1End = 0;
  let begin2End = 0;
  let begin3End = 0;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let end1End = 0;
  let end2End = 0;
  let end3End = 0;

  let object = Object.create( null );
  object.stage1 = 0;
  object.stage2 = 0;
  object.stage3 = 0;
  object.ready1 = new _.Consequence();
  object.ready2 = new _.Consequence();
  object.ready3 = new _.Consequence();
  object.begin1 = begin1;
  object.begin2 = begin2;
  object.begin3 = begin3;
  object.perform1 = perform1;
  object.perform2 = perform2;
  object.perform3 = perform3;
  object.end1 = end1;
  object.end2 = end2;
  object.end3 = end3;

  let stager = new _.Stager
  ({
    object : object,
    verbosity : 5,
    stageNames :        [ 'stage1', 'stage2', 'stage3' ],
    consequences :      [ object.ready1, object.ready2, object.ready3 ],
    onPerform :         [ perform1, perform2, perform3 ],
    onBegin :           [ begin1, begin2, begin3 ],
    onEnd :             [ end1, end2, end3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  test.description = 'state of stage1';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage1' );
  test.identical( got, exp );

  test.description = 'state of stage2';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage2' );
  test.identical( got, exp );

  test.description = 'state of stage3';
  var exp =
  {
    'skipping' : false,
    'pausing' : false,
    'errored' : false,
    'performed' : false,
    'begun' : false,
    'ended' : false
  }
  var got = stager.stageState( 'stage3' );
  test.identical( got, exp );

  stager.tick();

  return _.time.out( 1000, end );

  /* - */

  function begin1()
  {
    begin1End += 1;

    test.description = 'begin1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    begin1End += 1;
    return null;
  }

  function begin2()
  {
    begin2End += 1;

    test.description = 'begin2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'begin2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      begin2End += 1;
    });
  }

  function begin3()
  {
    begin3End += 1;

    test.description = 'begin3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    begin3End += 1;
    return null;
  }

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function end1()
  {
    end1End += 1;

    test.description = 'end1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 2 );

    end1End += 1;
    return null;
  }

  function end2()
  {
    end2End += 1;

    test.description = 'end2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 2 );

    return _.time.out( 50, () =>
    {
      test.description = 'end2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 2 );
      end2End += 1;
    });
  }

  function end3()
  {
    end3End += 1;

    test.description = 'end3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 2 );

    end3End += 1;
    return null;
  }

  function end()
  {

    test.description = 'were callbacks called';
    test.identical( begin1End, 2 );
    test.identical( begin2End, 2 );
    test.identical( begin3End, 2 );
    test.identical( perform1End, 2 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 2 );
    test.identical( end1End, 2 );
    test.identical( end2End, 2 );
    test.identical( end3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

  }

} /* end of function byVals */

//

function stageAccessor( test )
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

  let stager = new _.Stager
  ({
    object : object,
    verbosity : 5,
    stageNames :        [ 'stage1', 'stage2', 'stage3' ],
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
  });

  /* */

  test.description = 'set on stage2';
  stager.stageStateSkipping( 'stage2', 1 );
  stager.stageStatePausing( 'stage2', 1 );
  stager.stageStateErrored( 'stage2', 1 );
  stager.stageStatePerformed( 'stage2', 1 );

  test.description = 'get stage2';
  var got = stager.stageStateSkipping( 'stage2' );
  test.identical( got, true );
  var got = stager.stageStatePausing( 'stage2' );
  test.identical( got, true );
  var got = stager.stageStateErrored( 'stage2' );
  test.identical( got, true );
  var got = stager.stageStatePerformed( 'stage2' );
  test.identical( got, true );

  test.description = 'get stage1';
  var got = stager.stageStateSkipping( 'stage1' );
  test.identical( got, false );
  var got = stager.stageStatePausing( 'stage1' );
  test.identical( got, false );
  var got = stager.stageStateErrored( 'stage1' );
  test.identical( got, false );
  var got = stager.stageStatePerformed( 'stage1' );
  test.identical( got, false );

  test.description = 'get states of all stages';
  var got = stager.stageStateSkipping();
  test.identical( got, [ false, true, false ] );
  var got = stager.stageStatePausing();
  test.identical( got, [ false, true, false ] );
  var got = stager.stageStateErrored();
  test.identical( got, [ false, true, false ] );
  var got = stager.stageStatePerformed();
  test.identical( got, [ false, true, false ] );

  /* */

  test.description = 'set off stage2';
  stager.stageStateSkipping( 'stage2', 0 );
  stager.stageStatePausing( 'stage2', 0 );
  stager.stageStateErrored( 'stage2', 0 );
  stager.stageStatePerformed( 'stage2', 0 );

  test.description = 'get stage2';
  var got = stager.stageStateSkipping( 'stage2' );
  test.identical( got, false );
  var got = stager.stageStatePausing( 'stage2' );
  test.identical( got, false );
  var got = stager.stageStateErrored( 'stage2' );
  test.identical( got, false );
  var got = stager.stageStatePerformed( 'stage2' );
  test.identical( got, false );

  test.description = 'get stage1';
  var got = stager.stageStateSkipping( 'stage1' );
  test.identical( got, false );
  var got = stager.stageStatePausing( 'stage1' );
  test.identical( got, false );
  var got = stager.stageStateErrored( 'stage1' );
  test.identical( got, false );
  var got = stager.stageStatePerformed( 'stage1' );
  test.identical( got, false );

  test.description = 'get states of all stages';
  var got = stager.stageStateSkipping();
  test.identical( got, [ false, false, false ] );
  var got = stager.stageStatePausing();
  test.identical( got, [ false, false, false ] );
  var got = stager.stageStateErrored();
  test.identical( got, [ false, false, false ] );
  var got = stager.stageStatePerformed();
  test.identical( got, [ false, false, false ] );

  /* */

} /* end of function stageAccessor */

//

function stageAccessorBegunEnded( test )
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

  let stager = new _.Stager
  ({
    object : object,
    verbosity : 5,
    stageNames :        [ 'stage1', 'stage2', 'stage3' ],
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
  });

  /* */

  test.case = 'no set of current stage';

  test.description = 'set on stage2';
  test.shouldThrowErrorSync( () => stager.stageStateBegun( 'stage2', 1 ) );
  test.shouldThrowErrorSync( () => stager.stageStateEnded( 'stage2', 1 ) );

  test.description = 'get stage1';
  var got = stager.stageStateBegun( 'stage1' );
  test.identical( got, false );
  var got = stager.stageStateEnded( 'stage1' );
  test.identical( got, false );

  test.description = 'get stage2';
  var got = stager.stageStateBegun( 'stage2' );
  test.identical( got, false );
  var got = stager.stageStateEnded( 'stage2' );
  test.identical( got, false );

  test.description = 'get states of all stages';
  var got = stager.stageStateBegun();
  test.identical( got, [ false, false, false ] );
  var got = stager.stageStateEnded();
  test.identical( got, [ false, false, false ] );

  /* */

  test.case = 'set current stage2';
  stager.currentStage = 'stage2';

  test.description = 'get stage1';
  var got = stager.stageStateBegun( 'stage1' );
  test.identical( got, true );
  var got = stager.stageStateEnded( 'stage1' );
  test.identical( got, true );

  test.description = 'get stage2';
  var got = stager.stageStateBegun( 'stage2' );
  test.identical( got, false );
  var got = stager.stageStateEnded( 'stage2' );
  test.identical( got, false );

  test.description = 'get states of all stages';
  var got = stager.stageStateBegun();
  test.identical( got, [ true, false, false ] );
  var got = stager.stageStateEnded();
  test.identical( got, [ true, false, false ] );

  test.description = 'set on stage2';
  test.shouldThrowErrorSync( () => stager.stageStateBegun( 'stage2', 1 ) );
  test.shouldThrowErrorSync( () => stager.stageStateEnded( 'stage2', 1 ) );

  test.description = 'set on stage1';
  stager.stageStateBegun( 'stage1', 1 );
  stager.stageStateEnded( 'stage1', 1 );

  test.description = 'get stage1';
  var got = stager.stageStateBegun( 'stage1' );
  test.identical( got, true );
  var got = stager.stageStateEnded( 'stage1' );
  test.identical( got, true );

  test.description = 'get stage2';
  var got = stager.stageStateBegun( 'stage2' );
  test.identical( got, false );
  var got = stager.stageStateEnded( 'stage2' );
  test.identical( got, false );

  test.description = 'get states of all stages';
  var got = stager.stageStateBegun();
  test.identical( got, [ true, false, false ] );
  var got = stager.stageStateEnded();
  test.identical( got, [ true, false, false ] );

  /* */

  test.case = 'set current stage2 off with accessor';
  stager.currentStage = 'stage2';

  test.description = 'get states of all stages';
  var got = stager.stageStateBegun();
  test.identical( got, [ true, false, false ] );
  var got = stager.stageStateEnded();
  test.identical( got, [ true, false, false ] );

  test.description = 'set stage1 ended off';
  test.shouldThrowErrorSync( () => stager.stageStateBegun( 'stage1', 0 ) );
  test.shouldThrowErrorSync( () => stager.stageStateEnded( 'stage1', 0 ) );

  test.description = 'get stage1';
  var got = stager.stageStateBegun( 'stage1' );
  test.identical( got, true );
  var got = stager.stageStateEnded( 'stage1' );
  test.identical( got, true );

  test.description = 'get stage2';
  var got = stager.stageStateBegun( 'stage2' );
  test.identical( got, false );
  var got = stager.stageStateEnded( 'stage2' );
  test.identical( got, false );

  test.description = 'get states of all stages';
  var got = stager.stageStateBegun();
  test.identical( got, [ true, false, false ] );
  var got = stager.stageStateEnded();
  test.identical( got, [ true, false, false ] );

  /* */

} /* end of function stageAccessorBegunEnded */

//

function stageSkiping1( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage1', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'were callbacks called'
    test.identical( perform1End, 0 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;
    checkEnd();
    runEnd += 1;
    return null;
  }

  function run2end()
  {
    test.identical( runEnd, 2 );
    checkEnd();
    return null;
  }

} /* end of function stageSkiping1 */

//

function stageSkiping2( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage2', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;
    checkEnd();
    runEnd += 1;
    return null;
  }

  function run2end()
  {
    test.identical( runEnd, 2 );
    checkEnd();
    return null;
  }

} /* end of function stageSkiping2 */

//

function stageSkiping3( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage3', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 0 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;
    checkEnd();
    runEnd += 1;
    return null;
  }

  function run2end()
  {
    test.identical( runEnd, 2 );
    checkEnd();
    return null;
  }

} /* end of function stageSkiping3 */

//

function stageCancel1( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage1', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;

    test.case = 'run1end';
    checkEnd();

    test.description = 'were callbacks called'
    test.identical( perform1End, 0 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 2 );

    /* */

    test.description = 'reset';
    stager.cancel();

    /* */

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'were callbacks called'
    test.identical( perform1End, 0 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    debugger;
    stager.tick();

    runEnd += 1;
    return null;
  }

  function run2end()
  {

    test.case = 'run2end';
    test.identical( runEnd, 2 );

    checkEnd();

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );

    test.description = 'were callbacks called'
    test.identical( perform1End, 0 );
    test.identical( perform2End, 4 );
    test.identical( perform3End, 4 );

    return null;
  }

} /* end of function stageCancel1 */

//

function stageCancel2( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage2', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;

    test.case = 'run1end';
    checkEnd();

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    /* */

    debugger;
    test.description = 'reset';
    stager.cancel();

    /* */

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    debugger;
    stager.tick();

    runEnd += 1;
    return null;
  }

  function run2end()
  {

    test.case = 'run2end';
    test.identical( runEnd, 2 );

    checkEnd();

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );

    test.description = 'were callbacks called'
    test.identical( perform1End, 4 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 4 );

    return null;
  }

} /* end of function stageCancel2 */

//

function stageCancel3( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage3', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;

    test.case = 'run1end';
    checkEnd();

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 0 );

    /* */

    debugger;
    test.description = 'reset';
    stager.cancel();

    /* */

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 0 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    debugger;
    stager.tick();

    runEnd += 1;
    return null;
  }

  function run2end()
  {

    test.case = 'run2end';
    test.identical( runEnd, 2 );

    checkEnd();

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );

    test.description = 'were callbacks called'
    test.identical( perform1End, 4 );
    test.identical( perform2End, 4 );
    test.identical( perform3End, 0 );

    return null;
  }

} /* end of function stageCancel3 */

//

function stageCancelBut1( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage2', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;

    test.case = 'run1end';
    checkEnd();

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    /* */

    debugger;
    test.description = 'reset';
    stager.cancel({ but : 'stage1' });

    /* */

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : false,
      'ended' : false
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    debugger;
    stager.tick();

    runEnd += 1;
    return null;
  }

  function run2end()
  {

    test.case = 'run2end';
    test.identical( runEnd, 2 );

    checkEnd();

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 4 );

    return null;
  }

} /* end of function stageCancelBut1 */

//

function stageSkiping2Reset1( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage2', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;

    test.case = 'run1end';
    checkEnd();

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    /* */

    debugger;
    test.description = 'reset';
    stager.stageReset( 'stage1' );

    /* */

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    debugger;
    stager.tick();

    runEnd += 1;
    return null;
  }

  function run2end()
  {

    debugger;
    test.case = 'run2end';
    test.identical( runEnd, 2 );

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );

    test.description = 'were callbacks called'
    test.identical( perform1End, 4 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

} /* end of function stageSkiping2Reset1 */

//

function stageSkiping2Reset2( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage2', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;

    test.case = 'run1end';
    checkEnd();

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    /* */

    debugger;
    test.description = 'reset';
    stager.stageReset( 'stage2' );

    /* */

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    debugger;
    stager.tick();

    runEnd += 1;
    return null;
  }

  function run2end()
  {

    debugger;
    test.case = 'run2end';
    test.identical( runEnd, 2 );

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

} /* end of function stageSkiping2Reset2 */

//

function stageSkiping2Reset3( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage2', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;

    test.case = 'run1end';
    checkEnd();

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    /* */

    debugger;
    test.description = 'reset';
    stager.stageReset( 'stage3' );

    /* */

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true,
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    debugger;
    stager.tick();

    runEnd += 1;
    return null;
  }

  function run2end()
  {

    debugger;
    test.case = 'run2end';
    test.identical( runEnd, 2 );

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 4 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

} /* end of function stageSkiping2Reset3 */

//

function stageSkiping2Reset23( test )
{
  let self = this;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let runEnd = 0;

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
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ perform1, perform2, perform3 ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.stageStateSkipping( 'stage2', 1 );
  stager.tick();

  object.ready3.then( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : true,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end()
  {
    runEnd += 1;

    test.case = 'run1end';
    checkEnd();

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    /* */

    debugger;
    test.description = 'reset';
    stager.stageReset( 'stage2' );
    stager.stageReset( 'stage3' );

    /* */

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 0 );
    test.identical( perform3End, 2 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 0 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : false,
      'begun' : false,
      'ended' : false,
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    debugger;
    stager.tick();

    runEnd += 1;
    return null;
  }

  function run2end()
  {

    debugger;
    test.case = 'run2end';
    test.identical( runEnd, 2 );

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );

    test.description = 'were callbacks called'
    test.identical( perform1End, 2 );
    test.identical( perform2End, 2 );
    test.identical( perform3End, 4 );

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

} /* end of function stageSkiping2Reset23 */

//

function stageError2( test )
{
  let self = this;
  let begin1End = 0;
  let begin2End = 0;
  let begin3End = 0;
  let perform1End = 0;
  let perform2End = 0;
  let perform3End = 0;
  let end1End = 0;
  let end2End = 0;
  let end3End = 0;
  let runEnd = 0;

  let object = Object.create( null );
  object.stage1 = 0;
  object.stage2 = 0;
  object.stage3 = 0;
  object.ready1 = new _.Consequence();
  object.ready2 = new _.Consequence();
  object.ready3 = new _.Consequence();
  object.begin1 = begin1;
  object.begin2 = begin2;
  object.begin3 = begin3;
  object.perform1 = perform1;
  object.perform2 = perform2;
  object.perform3 = perform3;
  object.end1 = end1;
  object.end2 = end2;
  object.end3 = end3;

  let stager = new _.Stager
  ({
    object : object,
    verbosity : 5,
    stageNames :        [ 'stage1', 'stage2', 'stage3' ],
    consequences :      [ 'ready1', 'ready2', 'ready3' ],
    onPerform :         [ 'perform1', 'perform2', 'perform3' ],
    onBegin :           [ 'begin1', 'begin2', 'begin3' ],
    onEnd :             [ 'end1', 'end2', 'end3' ],
  });

  test.description = 'stage and phase';
  test.identical( stager.currentStage, 'stage1' );
  test.identical( stager.currentPhase, 0 );

  stager.tick();

  object.ready3.finally( run1end );

  return _.time.out( 1000, run2end );

  /* - */

  function begin1()
  {
    begin1End += 1;

    test.description = 'begin1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    begin1End += 1;
    return null;
  }

  function begin2()
  {
    begin2End += 1;

    test.description = 'begin2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'begin2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      begin2End += 1;
    });
  }

  function begin3()
  {
    begin3End += 1;

    test.description = 'begin3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    begin3End += 1;
    return null;
  }

  function perform1()
  {
    perform1End += 1;

    test.description = 'perform1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 1 );

    perform1End += 1;
    return null;
  }

  function perform2()
  {
    perform2End += 1;

    test.description = 'perform2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 1 );

    return _.time.out( 50, () =>
    {
      test.description = 'perform2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 1 );
      throw _.err( 'Error!' );
      perform2End += 1;
    });
  }

  function perform3()
  {
    perform3End += 1;

    test.description = 'perform3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 1 );

    perform3End += 1;
    return null;
  }

  function end1()
  {
    end1End += 1;

    test.description = 'end1';
    test.identical( stager.currentStage, 'stage1' );
    test.identical( stager.currentPhase, 2 );

    end1End += 1;
    return null;
  }

  function end2()
  {
    end2End += 1;

    test.description = 'end2';
    test.identical( stager.currentStage, 'stage2' );
    test.identical( stager.currentPhase, 2 );

    return _.time.out( 50, () =>
    {
      test.description = 'end2';
      test.identical( stager.currentStage, 'stage2' );
      test.identical( stager.currentPhase, 2 );
      end2End += 1;
    });
  }

  function end3()
  {
    end3End += 1;

    test.description = 'end3';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 2 );

    end3End += 1;
    return null;
  }

  function checkEnd()
  {

    test.description = 'stage and phase';
    test.identical( stager.currentStage, 'stage3' );
    test.identical( stager.currentPhase, 3 );

    test.description = 'state of stage1';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : false,
      'performed' : true,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage1' );
    test.identical( got, exp );

    test.description = 'state of stage2';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : true,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage2' );
    test.identical( got, exp );

    test.description = 'state of stage3';
    var exp =
    {
      'skipping' : false,
      'pausing' : false,
      'errored' : true,
      'performed' : false,
      'begun' : true,
      'ended' : true
    }
    var got = stager.stageState( 'stage3' );
    test.identical( got, exp );

    return null;
  }

  function run1end( err, arg )
  {
    runEnd += 1;

    test.is( _.errIs( err ) );
    test.is( !_.errIsAttended( err ) );
    _.errAttend( err );

    checkEnd();

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 0 / 0' );
    test.identical( object.ready1.errorsCount(), 0 );
    test.identical( object.ready2.errorsCount(), 1 );
    test.identical( object.ready3.errorsCount(), 0 );

    runEnd += 1;
    if( err )
    throw err;
    return arg;
  }

  function run2end()
  {

    test.description = 'were callbacks called'
    test.identical( begin1End, 2 );
    test.identical( begin2End, 2 );
    test.identical( begin3End, 2 );
    test.identical( perform1End, 2 );
    test.identical( perform2End, 1 );
    test.identical( perform3End, 0 );
    test.identical( end1End, 2 );
    test.identical( end2End, 2 );
    test.identical( end3End, 2 );
    test.identical( runEnd, 2 );

    test.identical( object.ready1.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready2.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready3.exportString({ verbosity : 1 }), 'Consequence:: 1 / 0' );
    test.identical( object.ready1.errorsCount(), 0 );
    test.identical( object.ready2.errorsCount(), 1 );
    test.identical( object.ready3.errorsCount(), 1 );

    checkEnd();
    return null;
  }

} /* end of function stageError2 */

// --
// define class
// --

var Self =
{

  name : 'Tools.amid.Stager',
  silencing : 1,

  tests :
  {

    trivial,
    make,
    byNames,
    byVals,

    stageAccessor,
    stageAccessorBegunEnded,

    stageSkiping1,
    stageSkiping2,
    stageSkiping3,

    stageCancel1,
    stageCancel2,
    stageCancel3,

    stageCancelBut1,
    // stageCancelBut2, // qqq : implement please
    // stageCancelBut3, // qqq : implement please

    // stageSkiping1Reset1, // qqq : implement please
    // stageSkiping1Reset2, // qqq : implement please
    // stageSkiping1Reset3, // qqq : implement please

    stageSkiping2Reset1,
    stageSkiping2Reset2,
    stageSkiping2Reset3,

    // stageSkiping3Reset1, // qqq : implement please
    // stageSkiping3Reset2, // qqq : implement please
    // stageSkiping3Reset3, // qqq : implement please

    stageSkiping2Reset23,

    stageError2,

  }

}

// --
// export
// --

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
