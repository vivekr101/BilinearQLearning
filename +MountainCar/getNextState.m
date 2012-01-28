function nextStates = getNextState(states, actions)
%{
Function that returns the next states given a matrix of current states
and actions taken.

Args:
    states: matrix of current states, one per row.
    actions: matrix of actions taken, one per row.

Returns:
    nextStates: matrix of next states, one per row.
%}

global gravity;

nextPos = states(:,1) + states(:,2);
nextVelocity = states(:,2) + actions(:,1) + gravity*cos(3*states(:,1));

nextVelocity(nextPos<-1.2) = 0;
nextPos(nextPos<-1.2) = -1.2;
nextVelocity(nextVelocity<-0.07) = -0.07;
nextVelocity(nextVelocity>0.07) = 0.07;

nextStates = [nextPos nextVelocity];