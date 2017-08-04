function plotEPMTrial

directories = uipickfiles('Type',{'*Test*.csv','Anymaze Trial File'});

for i=1:length(directories)
    
    % Import the data
    csvData = importdata(directories{i});
    % This creates two arrays, with doubles and one with cells
    % The cell array  has the full dimensions but only the titles and time
    % strings
    % The double array is missing the title row and the time column
      
    % convert text time to number time
    for j=2:length(csvData.textdata(1:end,1))
        DateVector = datevec(csvData.textdata(j,1),'HH:MM:SS.FFF');
        time(j-1) =  DateVector(5)*60 + DateVector(6);
    end
    
    % Find column indexes in csv file
    for j=1:length(csvData.textdata(1,1:end))
        if strcmp(csvData.textdata{1,j},'Centre posn X') == 1
            xPosInx = j-1;
        end
        if strcmp(csvData.textdata{1,j},'Centre posn Y') == 1
            yPosInx = j-1;
        end
        if strcmp(csvData.textdata{1,j},'In Center') == 1
            inCenterInx = j-1;
        end
        if strcmp(csvData.textdata{1,j},'In Open Arms') == 1
            inOpenInx = j-1;
        end
        if strcmp(csvData.textdata{1,j},'In Closed Arms') == 1
            inClosedInx = j-1;
        end
    end
     
    %% Parse entries and time
    centerEntries = 0;
    closedEntries = 0;
    openEntries = 0;
    timeInCenter = 0;
    timeInOpen = 0;
    timeInClosed = 0;
    centerCounter = 1;
    openCounter = 1;
    closedCounter = 1;
    
    for j=2:length(csvData.data(1:end,1))
        % Check if made entry to center
        if csvData.data(j-1,inCenterInx) == 0 && csvData.data(j,inCenterInx) == 1
            centerEntries = centerEntries + 1;
        end
        % Check if made entry to open arms
        if csvData.data(j-1,inOpenInx) == 0 && csvData.data(j,inOpenInx) == 1
            openEntries = openEntries + 1;
        end
        % Check if made entry to closed arms
        if csvData.data(j-1,inClosedInx) == 0 && csvData.data(j,inClosedInx) == 1
            closedEntries = closedEntries + 1;
        end
        %calculate time in each zone
        if csvData.data(j,inCenterInx) == 1
            centerTime(1,centerCounter) = time(j);
            centerTime(2,centerCounter) = csvData.data(j,xPosInx);
            centerTime(3,centerCounter) = csvData.data(j,yPosInx);
            timeInCenter = timeInCenter + time(j)-time(j-1);
            centerCounter = centerCounter + 1;
        elseif csvData.data(j,inOpenInx) == 1
            openTime(1,openCounter) = time(j);
            openTime(2,openCounter) = csvData.data(j,xPosInx);
            openTime(3,openCounter) = csvData.data(j,yPosInx);
            timeInOpen = timeInOpen + time(j)-time(j-1);
            openCounter = openCounter + 1;
        elseif csvData.data(j,inClosedInx) == 1
            closedTime(1,closedCounter) = time(j);
            closedTime(2,closedCounter) = csvData.data(j,xPosInx);
            closedTime(3,closedCounter) = csvData.data(j,yPosInx);
            timeInClosed = timeInClosed + time(j)-time(j-1);
            closedCounter = closedCounter + 1;
        end
    end
    
    % Make the figure
    
    fig = figure('Position',[50 50 1000 800]);
    % Plot of animals location
    subplot(3,3,[1,2,4,5])
    hold on;
    plot(closedTime(2,:),closedTime(3,:),'.k');
    plot(centerTime(2,:),centerTime(3,:),'.y');
    plot(openTime(2,:),openTime(3,:),'.r');
    % format the plot
    [~, trialName] = fileparts(directories{i});
    title(trialName);
    xlim([min(csvData.data(2:end,1)),max(csvData.data(2:end,1))]);
    ylim([min(csvData.data(2:end,2)),max(csvData.data(2:end,2))]);
    box off;
    set(gca,'xcolor',get(gcf,'color'));
    set(gca,'xtick',[]);
    set(gca,'ycolor',get(gcf,'color'));
    set(gca,'ytick',[]);
    axis square;
    legend({'Closed Arms' 'Center' 'Open Arms'});
    legend('boxoff');
    
    % plot time in each arm
    subplot(3,3,3)
    hold on;
    bar(1,timeInClosed,'k');
    bar(2,timeInCenter,'y');
    bar(3,timeInOpen,'r');
    % format the plot
    set(gca,'XTickLabel',{'' 'Closed','Center','Open' ''},'fontsize',8);
    xlim([0,4]);
    ylim([0,600]);
    set(gca,'xtick',[0 1 2 3 4]);
    title('Time');
    ylabel('Time');
    
    % Plot of entries to different zones
    subplot(3,3,6)
    hold on;
    bar(1,closedEntries,'k');
    bar(2,centerEntries,'y');
    bar(3,openEntries,'r');
    % format the plot
    set(gca,'XTickLabel',{'' 'Closed','Center','Open' ''},'fontsize',8);
    xlim([0,4]);
    ylim([0,100]);
    set(gca,'xtick',[0 1 2 3 4]);
    title('Entries')
    ylabel('Number of Entries');
    
    %Plot location of the mouse over time
    subplot(3,3,[7 8 9])
    hold on;
    plot(closedTime(1,:),.9,'.k');
    plot(centerTime(1,:),1,'.y');
    plot(openTime(1,:),1.1,'.r');
    % format the plot
    ylim([0,3]);
    xlabel('Time');
    box off;
    set(gca,'ytick',[]);
    set(gca,'ycolor',get(gcf,'color'));
%     legend({'Closed Arms' 'Center' 'Open Arms'});
%     legend('boxoff');
    
    fileName = [trialName,'_summary.jpg'];
    saveas(fig,fileName);
    crop([pwd '/' fileName]);
    close all;
    
    clear centerTime closedTime openTime time;
end

end