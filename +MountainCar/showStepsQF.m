function showStepsQF(model)
global xMean xMax xMin;
options = optimset('Display','notify','GradObj','Off','LargeScale','Off');

while(true)
    clc;
    h=0;
    %state=[(rand(1,1)-0.5)*(xMax-xMin) + xMean 0];
    state=[-acos(0)/3 0];
    while(true) 
        if(MountainCar.isGoalState(state)==1)  
            fprintf(1,'\n\nGoal State Reached.\n'); 
            break 
        end
        
        [rew, a] = MountainCar.getOptimalAction(model, MountainCar.getStateTransformations(state));
        
        clc;
        fprintf(1,'New State: (%f,%f) with reward %f, action (%f)\n',state(1),state(2),rew,a(1)); 
        
        
        state(1,2)=state(1,2)+a(1,1)-0.0025*cos(3*state(1,1));
        if(state(1,2)<-0.07)
            state(1,2)=-0.07;
        end
        if(state(1,2)>0.07)
            state(1,2)=0.07;
        end
        
        state(1,1)=state(1,1)+state(1,2);
        
        if(state(1,1)<-1.2)
            state(1,1)=-1.2;
            if(state(1,2)<0)
                state(1,2)=0;
            end
        end
        
        h=plot([-1.2:0.1:0.5],1/3*sin(3*[-1.2:0.1:0.5]));
        hold on;
        scatter(state(1,1),1/3*sin(3*state(1,1)));
        hold off;
        drawnow;
        pause(0.1); 
    end
    [x,y,button] = ginput(1);
    close all;
    if(button==3)
        break
    end
end