function accMat = TwoBets_accruracy(grpVec)
% This function computes the 1st and the 2nd choice accuracy, 
% as well as the choice accuracy by their corresponding bet.
% Note: Sometimes there are NaNs in the accMat. This is because 
% there is no such a condition for a certain subject. e.g., If a 
% subject only bet on 3, the acc value for bet 1/2 will be NaN.

nGrp        = length(grpVec); 
accMatByGrp = zeros(5,6,nGrp);
accMat      = [];

n = 1;
for j = grpVec
   [~,~,~,~,~,~,~,~,~,~, accMatByGrp(:,:,n)] = TwoBets_choiceSwitchbyGroup_RVSL (j);
   accMat = vertcat(accMat, accMatByGrp(:,:,n));
   n = n+1;
end

% keyboard
meanAcc = nanmean(accMat);
mean1 = mean(meanAcc(1:3));
mean2 = mean(meanAcc(4:6));

% keyboard

f1 = figure;
set(f1,'color',[1 1 1]);
set(f1,'position',[2200 300 500 400]);

bar (1, mean1,0.9,'g')
hold on
bar (3, mean2,0.9,'r')
errorbar(mean1,nansem([accMat(:,1); accMat(:,2); accMat(:,3)]),'LineStyle','none','color',[0 0 0])
errorbar(mean2,nansem([accMat(:,4); accMat(:,5); accMat(:,6)]),'LineStyle','none','XData',3,'color',[0 0 0])
hold off

a = get(f1,'children'); 
ylabel('response accuracy (%)', 'FontSize', 15)
set(gca, 'FontSize', 11)
set(a,'box','off','TickDir','out', 'YLim',[0,0.75], 'XLim',[0 4])
set(a,'XTick',[1 3],'XTickLabel', {'First Choice','Second Choice'})
set(a,'YTickLabel', {'0','.1','.2','.3','.4','.5','.6','.7'})


f2 = figure;
set(f2,'color',[1 1 1]);
set(f2,'position',[2200 300 700 400]);

bar ([1 2 3], nanmean(accMat(:,1:3)),0.9,'g')
hold on
bar ([5 6 7], nanmean(accMat(:,4:6)),0.9,'r')
errorbar(nanmean(accMat(:,1:3)),nansem(accMat(:,1:3)),'LineStyle','none','color',[0 0 0])
errorbar(nanmean(accMat(:,4:6)),nansem(accMat(:,4:6)),'LineStyle','none','XData',[5 6 7],'color',[0 0 0])
text(1.3, -0.08, 'first choice', 'FontSize', 15)
text(5.2, -0.08, 'second choice', 'FontSize', 15)
line([0.5 3.5], [mean1 mean1],'color','k')
line([4.5 7.5], [mean2 mean2],'color','k')
hold off

a = get(f2,'children'); 
ylabel('response accuracy (%)', 'FontSize', 15)
set(gca, 'FontSize', 11)
set(a,'box','off','TickDir','out', 'YLim',[0,0.75])
set(a,'XTick',[1 2 3 5 6 7],'XTickLabel', {'bet1','bet2','bet3','bet1','bet2','bet3'})
set(a,'YTickLabel', {'0','.1','.2','.3','.4','.5','.6','.7'})

% keyboard
