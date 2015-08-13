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
% optionPair(1), reverseNow(2), firstChoice(3), withORagainst(4), switchORnot(5),
% first choices of others x 4(6-9), secondChoice(10),
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
            NaN, NaN, NaN, NaN, rawData(j).totalOutcome(k),...
            rawData(j).winProb1, rawData(j).decision1.israndom(k), NaN,...
            nan(1,4)] ;
        
        if j > 1 && rawData(j).winProb1 ~= rawData(j-1).winProb1
            data(k).choice(j,2) = 1; % reverse now
        else
            data(k).choice(j,2) = 0; % don't reverse
        end
        
        % check switch or not: 0 for not swtich, 1 for switch
        if data(k).choice(j,3) == data(k).choice(j,10)
            data(k).choice(j,5) = 0;
        else
            data(k).choice(j,5) = 1;
        end
        
        % 1st choice with missing data measures
        if data(k).choice(j,41) == 1
            data(k).choice(j,42)=NaN;
        else
            data(k).choice(j,42)= data(k).choice(j,3);
        end
        
        % otherChoices' with or against index (43-46)
        data(k).choice(j,43:46) = data(k).choice(j,3) == data(k).choice(j,6:9);
        
    end  % for 1:nTrials
    
end

