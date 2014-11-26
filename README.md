prolog-fiddle
=============
#Quickstart
```bash
git clone git@github.com:samwong1990/prolog-fiddle.git
brew install swi-prolog
cd prolog-fiddle
swipl
```
#Why are you doing this
I want to explore the viability of defining business logic in Prolog.

#What is it supposed to do
We have these Events predefined in the loanOps.pl
```prolog
% Events formats:
% borrow(Amount, Duration)
% repay(OnDay, Amount).
% topup(OnDay, Amount).
% extend(OnDay, Days).
% default(OnDay).

borrow(100, 14).
repay(3, 50).
topUp(5, 100).
extend(13, 14).
repay(29, 1000).
```
Now we can query the state of the loan on any day using

<code>simulation(CurrentDay, InterestBearingBalance, NonInterestBearingBalance, Interest)</code>
```prolog
?- consult('loanOps.pl').
% loanOps.pl compiled 0.00 sec, 1 clauses
true.

?- simulation(3, InterestBearingBalance, NonInterestBearingBalance, Interest).
Day 00, InterestBearingBalance 105.50, NonInterestBearingBalance 0.00, Interest 1.06, TotalBalance 106.56
Day 01, InterestBearingBalance 105.50, NonInterestBearingBalance 0.00, Interest 2.11, TotalBalance 107.61
Day 02, InterestBearingBalance 105.50, NonInterestBearingBalance 0.00, Interest 3.17, TotalBalance 108.67
Day 03, InterestBearingBalance 55.50, NonInterestBearingBalance 0.00, Interest 3.72, TotalBalance 59.22
InterestBearingBalance = 0+211 rdiv 2+0+0+ -50,
NonInterestBearingBalance = 0+0+0+0+0,
Interest = 0+ (0+211 rdiv 2)* (5764607523034235 rdiv 576460752303423488)+ (0+211 rdiv 2+0)* (5764607523034235 rdiv 576460752303423488)+ (0+211 rdiv 2+0+0)* (5764607523034235 rdiv 576460752303423488)+ (0+211 rdiv 2+0+0+ -50)* (5764607523034235 rdiv 576460752303423488)
```
```prolog
?- simulation(30, InterestBearingBalance, NonInterestBearingBalance, Interest).
Day 00, InterestBearingBalance 105.50, NonInterestBearingBalance 0.00, Interest 1.06, TotalBalance 106.56
Day 01, InterestBearingBalance 105.50, NonInterestBearingBalance 0.00, Interest 2.11, TotalBalance 107.61
Day 02, InterestBearingBalance 105.50, NonInterestBearingBalance 0.00, Interest 3.17, TotalBalance 108.67
Day 03, InterestBearingBalance 55.50, NonInterestBearingBalance 0.00, Interest 3.72, TotalBalance 59.22
Day 04, InterestBearingBalance 55.50, NonInterestBearingBalance 0.00, Interest 4.28, TotalBalance 59.78
Day 05, InterestBearingBalance 161.00, NonInterestBearingBalance 0.00, Interest 5.89, TotalBalance 166.89
Day 06, InterestBearingBalance 161.00, NonInterestBearingBalance 0.00, Interest 7.50, TotalBalance 168.50
Day 07, InterestBearingBalance 161.00, NonInterestBearingBalance 0.00, Interest 9.11, TotalBalance 170.11
Day 08, InterestBearingBalance 161.00, NonInterestBearingBalance 0.00, Interest 10.72, TotalBalance 171.72
Day 09, InterestBearingBalance 161.00, NonInterestBearingBalance 0.00, Interest 12.33, TotalBalance 173.33
Day 10, InterestBearingBalance 161.00, NonInterestBearingBalance 0.00, Interest 13.94, TotalBalance 174.94
Day 11, InterestBearingBalance 161.00, NonInterestBearingBalance 0.00, Interest 15.55, TotalBalance 176.55
Day 12, InterestBearingBalance 161.00, NonInterestBearingBalance 0.00, Interest 17.16, TotalBalance 178.16
Day 13, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 18.87, TotalBalance 189.87
Day 14, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 20.58, TotalBalance 191.58
Day 15, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 22.29, TotalBalance 193.29
Day 16, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 24.00, TotalBalance 195.00
Day 17, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 25.71, TotalBalance 196.71
Day 18, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 27.42, TotalBalance 198.42
Day 19, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 29.13, TotalBalance 200.13
Day 20, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 30.84, TotalBalance 201.84
Day 21, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 32.55, TotalBalance 203.55
Day 22, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 34.26, TotalBalance 205.26
Day 23, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 35.97, TotalBalance 206.97
Day 24, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 37.68, TotalBalance 208.68
Day 25, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 39.39, TotalBalance 210.39
Day 26, InterestBearingBalance 171.00, NonInterestBearingBalance 0.00, Interest 41.10, TotalBalance 212.10
Defaulted on Day  27
Day 27, InterestBearingBalance 171.00, NonInterestBearingBalance 20.00, Interest 42.81, TotalBalance 233.81
Day 28, InterestBearingBalance 171.00, NonInterestBearingBalance 20.00, Interest 44.52, TotalBalance 235.52

Loan has been Paid off
Day 29, InterestBearingBalance 0.00, NonInterestBearingBalance 0.00, Interest -764.48, TotalBalance -764.48

Loan has been Paid off
Day 30, InterestBearingBalance 0.00, NonInterestBearingBalance 0.00, Interest -764.48, TotalBalance -764.48
```

#TODO
I have something that works, now I have to extract business logic.
e.g. define rebalance using a clear logic program.
