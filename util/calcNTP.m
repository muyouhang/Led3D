function [ nose_point ] = calcNoseTip( landmarks )
    if landmarks(1,3)~=0 && landmarks(2,3)~=0
        nose_point=landmarks(:,3);
        return;
    else
        nose_point=-1;
        if landmarks(1,1)~=0
            if landmarks(1,2)~=0
                nose_point=[(landmarks(1,1)+landmarks(1,2))/2 (landmarks(2,1)+landmarks(2,2))/2+10];
            elseif landmarks(1,4)~=0
                nose_point=[(landmarks(1,1)+landmarks(1,4))/2+10 (landmarks(2,1)+landmarks(2,4))/2];
            elseif landmarks(1,5)~=0
                nose_point=[(landmarks(1,1)+landmarks(1,5))/2 (landmarks(2,1)+landmarks(2,5))/2];
            end
        elseif landmarks(1,2)~=0
            if landmarks(1,4)~=0
                nose_point=[(landmarks(1,2)+landmarks(1,4))/2 (landmarks(2,2)+landmarks(2,4))/2];
            elseif landmarks(1,5)~=0
                nose_point=[(landmarks(1,2)+landmarks(1,5))/2-10 (landmarks(2,2)+landmarks(2,5))/2];
            end
        elseif landmarks(1,4)~=0
            if landmarks(1,5)~=0
                nose_point=[(landmarks(1,2)+landmarks(1,4))/2 (landmarks(2,2)+landmarks(2,4))/2-15];
            end
        end
        return;
    end

end

