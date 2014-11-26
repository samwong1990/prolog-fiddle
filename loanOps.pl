% Allow these events to be declared anywhere in the source file.
:- discontiguous(borrow/2). % borrow(Amount, Duration)
:- discontiguous(repay/2). % repay(OnDay, Amount).
:- discontiguous(topup/2). % topup(OnDay, Amount).
:- discontiguous(extend/2). % extend(OnDay, Days).
:- discontiguous(default/1). % default(OnDay).

% Constants
simpleInterestPerDay(A) :- A is rational(0.01).
transmissionFee(A) :- A is rational(5.5).
topUpFee(A) :- A is rational(5.5).
extensionFee(A) :- A is rational(10).
defaultFee(A) :- A is rational(20).

% Events
borrow(100, 14).
repay(3, 50).
topUp(5, 100).
extend(13, 14).
repay(29, 1000).

% Base Case
simulation(CurrentDay, InterestBearingBalance, NonInterestBearingBalance, Interest) :-
    CurrentDay < 0,
    InterestBearingBalance is 0,
    NonInterestBearingBalance is 0,
    Interest is 0.

% Top down recursion
simulation(CurrentDay, InterestBearingBalance, NonInterestBearingBalance, Interest) :-
    CurrentDay >= 0,
    simpleInterestPerDay(InterestRate),
    PrevDay is CurrentDay-1,
    simulation(PrevDay, PrevIBB, PrevNIBB, PrevInterest),

    findall(Charge, interestBearingCharges(CurrentDay, Charge), AllInterestBearingCharges),
    findall(Charge, nonInterestBearingCharges(CurrentDay, Charge), AllNonInterestBearingCharges),
    sumlist(AllInterestBearingCharges, InterestBearingCharges),
    sumlist(AllNonInterestBearingCharges, NonInterestBearingCharges),

    DraftInterestBearingBalance = PrevIBB + InterestBearingCharges,
    DraftNonInterestBearingBalance = PrevNIBB + NonInterestBearingCharges,
    DraftInterest = PrevInterest + InterestBearingBalance*InterestRate,

    rebalance([DraftInterestBearingBalance, DraftNonInterestBearingBalance, DraftInterest], [InterestBearingBalance, NonInterestBearingBalance, Interest]),

    TotalBalance is InterestBearingBalance + NonInterestBearingBalance + Interest,
    format('Day ~|~`0t~d~2+, InterestBearingBalance ~2f, NonInterestBearingBalance ~2f, Interest ~2f, TotalBalance ~2f~n', [CurrentDay, InterestBearingBalance, NonInterestBearingBalance, Interest, TotalBalance]).

%% Negative balance is used to pay off the loan from head to tail. e.g.
%% ?- rebalance([1,2,3],B).
%% B = [1, 2, 3].

%% ?- rebalance([0,2,3],B).
%% B = [0, 2, 3]

%% ?- rebalance([-1,2,3],B).
%% B = [0, 1, 3] ;

%% ?- rebalance([-2,2,3],B).
%% B = [0, 0, 3] ;

%% ?- rebalance([-5,2,3],B).
%% B = [0, 0, 0] ;

rebalance(A,B) :-
    A = [X],
    X =< 0,
    %% format('~nCongrats! Loan has been Paid off~n'),
    B = [X].

rebalance(A,B) :-
    A = [FST, SND | Tail],
    FST =< 0,
    B = [0 | Recurse],
    NewBalance is SND+FST,
    rebalance([NewBalance|Tail], Recurse).

rebalance(A,B) :-
    A = [Head|_],
    Head > 0,
    B = A.

% Helpers for aggregating applicable charges for the day
interestBearingCharges(OnDay, BorrowedAmount) :-
    borrow(BorrowedAmount, _),
    OnDay is 0.

interestBearingCharges(OnDay, RepaidAmount) :-
    repay(OnDay, Amount),
    RepaidAmount is -Amount.

interestBearingCharges(OnDay, ToppedUpAmount) :-
    topUp(OnDay, ToppedUpAmount).

interestBearingCharges(OnDay, TransmissionFee) :-
    transmissionFee(TransmissionFee),
    borrow(_, _),
    OnDay is 0.

interestBearingCharges(OnDay, TopUpFee) :-
    topUpFee(TopUpFee),
    topUp(OnDay, _).

interestBearingCharges(OnDay, ExtensionFee) :-
    extensionFee(ExtensionFee),
    extend(OnDay, _).

nonInterestBearingCharges(OnDay, DefaultFee) :-
    findall(DueDay,
        (   borrow(_, DueDay);
            extend(A,B), DueDay is A+B
        ), DueDays),
    max_list(DueDays, OnDay),
    format('Defaulted on Day  ~|~`0t~d~2+~n', [OnDay]),
    defaultFee(DefaultFee).


