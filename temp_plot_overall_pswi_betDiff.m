f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [2200 80 420 480])


%%% choice switch of not, overall

% with condition
o1 = plot(grdPSwitch_tt_with, 'o-');
hold on
set(o1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)

% against condition
o2 = plot(grdPSwitch_tt_agnst, 's--');
set(o2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)

% errorbar
e1 = errorbar(grdPSwitch_tt_with, semPSwitch_tt_with, 'color', 'b');
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 3);
e2 = errorbar(grdPSwitch_tt_agnst,semPSwitch_tt_agnst, 'color', 'r');
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 3);
hold off

t = legend('with group decisions','against group decisions','location','northwest');
set(t, 'FontSize',11)
set(gca,'FontSize', 11)
title('choice change probability after 1st decisions', 'FontSize', 15)
xlabel('group coherence', 'FontSize', 15)
ylabel('choice change probability (%)','FontSize', 15)
a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a(1),'box','off'); set(a(2),'box','off');
set(a(2),'TickDir','out');
set(a(2),'XTick',[1 2 3]);
set(a(2),'Xlim',[0.5 3.5]);
set(a(2),'Ylim',[0 0.65]);
set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a(2),'YTickLabel',{'0','10','20','30','40','50','60'});

%%


f2 = figure;
set(f2,'color',[1 1 1])
set(f2,'position', [2200 80 420 480])

%%% betDiff across the 1st bet ------------------------------

% with condition
o1 = plot(grdBetDiff_tt_with, 'o-');
hold on
set(o1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)

% against condition
o2 = plot(grdBetDiff_tt_agnst, 's--');
set(o2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)

% errorbar
e1 = errorbar(grdBetDiff_tt_with, semBetDiff_tt_with, 'color', 'b');
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 3);
e2 = errorbar(grdBetDiff_tt_agnst,semBetDiff_tt_agnst, 'color', 'r');
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 3);

% reference line '0'
ll = line([0.5 3.5], [0 0]);
set(ll,'Color','k', 'LineStyle', ':')

hold off

t = legend('with group decisions','against group decisions','location','northwest');
set(t, 'FontSize',11)
set(gca,'FontSize', 11)
title('Changes in Bets after 2nd decisions', 'FontSize', 15)
xlabel('group coherence', 'FontSize', 15)
ylabel('bet difference (bet2 - bet1)','FontSize', 15)
a = get(f2,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a(1),'box','off'); set(a(2),'box','off');
set(a(2),'TickDir','out');
set(a(2),'XTick',[1 2 3]);
set(a(2),'YTick',[-.2 0 .2]);
set(a(2),'Xlim',[0.5 3.5]);
set(a(2),'Ylim',[-.3 .5]);
set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a(2),'YTickLabel',{'-0.2','0','0.2'});


