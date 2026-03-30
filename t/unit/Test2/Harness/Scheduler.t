use Test2::V0 -target => 'Test2::Harness::Scheduler';

use Test2::Harness::Util::HashBase qw{};

subtest 'abort without runs terminates scheduler' => sub {
    my $scheduler = bless {
        runs    => {},
        running => { jobs => {} },
        plugins => [],
    }, $CLASS;

    ok(!$scheduler->terminated, 'not terminated before abort');
    $scheduler->abort();
    ok($scheduler->terminated, 'terminated after full abort');
};

subtest 'abort with specific runs does not terminate scheduler' => sub {
    my $run_id = 'run-123';

    my $run = mock {} => (
        add => [
            set_halt => sub { },
        ],
    );

    my $scheduler = bless {
        runs    => { $run_id => $run },
        running => { jobs => {} },
        plugins => [],
    }, $CLASS;

    ok(!$scheduler->terminated, 'not terminated before partial abort');
    $scheduler->abort($run_id);
    ok(!$scheduler->terminated, 'not terminated after partial abort');
};

subtest 'kill delegates to abort and terminates' => sub {
    my $scheduler = bless {
        runs    => {},
        running => { jobs => {} },
        plugins => [],
    }, $CLASS;

    $scheduler->kill();
    ok($scheduler->terminated, 'terminated after kill');
};

done_testing;
