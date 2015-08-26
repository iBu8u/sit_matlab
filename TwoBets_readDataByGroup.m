function data = TwoBets_readDataByGroup(grpID)
%TWOBETS_READDATABYGROUP only read and format data, without any coding.
% This is used specially for fitting the model, save several seconds.

data_dir = sprintf('F:\\projects\\SocialInflu\\data_MR\\Group_%d\\', grpID);
% load the data into rawData, rawData now is a 1-by-1 struct, containing
% the trial struct (1-by-100 struct)
rawData = load([data_dir sprintf('Group_%d_exp.mat', grpID)]);
% make rawdata 1-by-100, namely 100 trials
rawData = rawData.trial;


%% read data ====================================

% data format (headers):
% optionPair(1), reverseNow(2), 1st Choice(3), withORagainst(4), switchORnot(5),
% 1st choices of others x 4(6-9), 2nd Choice(10),
% majority of the other 4(11), group parameter(12),
% 1st bet(13), single 2nd outcome(14), majority outcome(15),
% majority of all the 5 players(16), 1st group coherence(17),
% 2nd group coherence(18), 2nd bet(19), bet difference (20),
% correct choice(21), 1st accuracy(22), 2nd accuracy(23),
% other group members' outcome (24-27), winner(28)
% 1st rt(29), 1st bet rt(30), 2nd rt(31), 2nd bet rt (32)
% 1st preference (33), 2nd preference (34)
% switch results compared to the others, considerting the pref (35-38)
% total outcome (39), winProb1 (40)
% count missing data (41)
% 1st choice with missing data (42)
% otherChoices' with or against index (43-46)
% recoded preference for the other 4 (47-50)
% weight according to preference, for Stan use (51-54)
% 2nd choice of others (55-58)
% weighted other value (59-60)
% moving-window choice frequency as the same as my 2nd choice (61-64)
% moving-window choice frequency as oppusite to my 2nd choice (65-68)
% 0/1 results, checking choice1 == otherChoice1 (69-72)


% data(1) refers the 1st client, data(2) refers the 2nd client, and so on
for k = 1:5 % 1:5 client
        
    for j = 1:length(rawData)  % 1:nTrial
        
        % load data in the defind format above
        data(k).choice(j,:) = [rawData(j).optionPair, NaN, rawData(j).decision1.choice(k), ...
            NaN, NaN, rawData(j).decision1.choice(setdiff([1 2 3 4 5], k)), ...
            rawData(j).decision2.choice(k), ...
            mode(rawData(j).decision1.choice(setdiff([1 2 3 4 5], k))), NaN,...
            rawData(j).bet1.choice(k), rawData(j).outcome2(k), ...
            mode(rawData(j).outcome2), mode(rawData(j).decision1.choice), NaN, NaN,...
            rawData(j).bet2.choice(k), NaN, NaN, NaN, NaN,...
            rawData(j).outcome2(setdiff([1 2 3 4 5], k)), rawData(j).winner,...
            rawData(j).decision1.rt(k), rawData(j).bet1.rt(k),...
            rawData(j).decision2.rt(k), rawData(j).bet2.rt(k),...
            rawData(j).pref1.choice(k), rawData(j).pref2.choice(k),...
            nan(1,4), rawData(j).totalOutcome(k),...
            rawData(j).winProb1, rawData(j).decision1.israndom(k), NaN,...
            nan(1,4), nan(1,4), nan(1,4), ...
            rawData(j).decision2.choice(setdiff([1 2 3 4 5], k)), ...
            nan(1,2), nan(1,8), nan(1,4)];
        
        if j > 1 && rawData(j).winProb1 ~= rawData(j-1).winProb1
            data(k).choice(j,2) = 1; % reverse now
        else
            data(k).choice(j,2) = 0; % don't reverse
        end
        
        % check switch or not: 0 for not swtich, 1 for switch ---------------------------------
        if data(k).choice(j,3) == data(k).choice(j,10)
            data(k).choice(j,5) = 0;
        else
            data(k).choice(j,5) = 1;
        end
        
        % 1st choice with missing data measures -----------------------------------------------
        if data(k).choice(j,41) == 1
            data(k).choice(j,42)=NaN;
        else
            data(k).choice(j,42)= data(k).choice(j,3);
        end
        
        % otherChoices' with or against index (43-46) -----------------------------------------
        data(k).choice(j,43:46) = data(k).choice(j,3) == data(k).choice(j,6:9);
        
        % manipulate and recode the prereference result ---------------------------------------
        % choice   = data(k).choice(j, 6:9);     % choices of the other 4
        tempPref = data(k).choice(j, 33:34);   % 1st and 2nd preference of the current subject
        if tempPref(2) ~= tempPref(1)
            remain     = setdiff(1:4, tempPref);     % the remaining subject
            pref       = [tempPref, remain];
            wght       = zeros(1,4);
            wght(pref) = [.75 .5 .25 .25];
        elseif tempPref(2) == tempPref(1)
            remain     = setdiff(1:4, tempPref(1));  % the remaining subject
            pref       = [tempPref(1), remain];
            wght       = zeros(1,4);
            wght(pref) = [1 .25 .25 .25];
        end
                        
        % orderChoice = choice( prefVec );  % odered choices by the preference
        data(k).choice(j,47:50) = pref;
        data(k).choice(j,51:54) = wght;
        
        %keyboard
        
        % weighted otherValue based on others' (2nd) choice and reward
        % note that only the 2nd choice leat to reward
        c2         = data(k).choice(j,10);
        othc2      = data(k).choice(j,55:58);
        othrew     = data(k).choice(j,24:27);
        tmpv       = zeros(1,2);
        tmpv(c2)   = sum(wght .* (othc2==c2) .* othrew);
        tmpv(3-c2) = sum(wght .* (othc2~=c2) .* othrew);
        data(k).choice(j,59:60) = tmpv;
               
    end  % for 1:nTrials
    
    % keyboard
    
    % build choice frequency over the past [window] trials, later for modeling -------------------
    int_window = 5;
    mc2 = data(k).choice(:,10);     % my C2
    oc2 = data(k).choice(:,55:58);  % other C2
    sum_choose_c2_y = zeros(100,4); % how many times they choose the same option as I do on the 2nd choice 
    sum_choose_c2_n = zeros(100,4); % how many times they choose the opposit option as I do on the 2nd choice 
        
    for t = 1:length(rawData) % trial loop
        if t <= 5
           sum_choose_c2_y(t,:) = sum( oc2(1:t,:)==mc2(t),1 );
           sum_choose_c2_n(t,:) = t - sum_choose_c2_y(t,:);
        else
           sum_choose_c2_y(t,:) = sum(oc2((t-int_window+1):t, :)==mc2(t),1 ) ;
           sum_choose_c2_n(t,:) = int_window - sum_choose_c2_y(t,:);
        end
    end    
    data(k).choice(:,61:64) = sum_choose_c2_y;
    data(k).choice(:,65:68) = sum_choose_c2_n;
    
    % 0/1 results for checking choice1 == otherChoice1, for RLcumrew -------------------------------
    mc1 = data(k).choice(:,3);     % my C1
    oc1 = data(k).choice(:,6:9);  % other C1
    data(k).choice(:,69:72) = (repmat(mc1,1,4) == oc1);
end

