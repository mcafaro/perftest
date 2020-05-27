function convertToJMeterCSV(results)

activityTable = vertcat(results.TestActivity);

samplesTable = activityTable(activityTable.Objective == categorical({'sample'}),:);
nrows = size(samplesTable, 1);

% Trim the table and change variable names to comply with JMeter CSV format
samplesTable = samplesTable(:, {'Timestamp', 'MeasuredTime', 'Name', 'Passed'});
samplesTable.Properties.VariableNames = {'timeStamp', 'elapsed', 'label', 'success'};

% Convert timestamp to unix format, and fill NaT with previous available time
samplesTable.timeStamp = fillmissing(samplesTable.timeStamp,'previous');
samplesTable.timeStamp = posixtime(samplesTable.timeStamp)*1000;
samplesTable.timeStamp = uint64(samplesTable.timeStamp);

% Convert MeasuredTime to millisecond, and fill NaN with 0
samplesTable.elapsed = fillmissing(samplesTable.elapsed,'constant',0);
samplesTable.elapsed = floor(samplesTable.elapsed*1000);

% Convert pass/fail logical to string
samplesTable.success = string(samplesTable.success);

% Generate additional columns required in JMeter CSV format
responseCode = zeros(nrows, 1);
responseMessage = strings(nrows, 1);
threadName = strings(nrows, 1);
dataType = strings(nrows, 1);
failureMessage = strings(nrows, 1);
bytes = zeros(nrows, 1);
sentBytes = zeros(nrows, 1);
grpThreads = ones(nrows, 1);
allThreads = ones(nrows, 1);
Latency = zeros(nrows, 1);
IdleTime = zeros(nrows, 1);
Connect = zeros(nrows, 1);

%timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,failureMessage,bytes,sentBytes,grpThreads,allThreads,Latency,IdleTime,Connect

auxTable = table(responseCode, responseMessage, threadName, dataType, ...
    failureMessage, bytes, sentBytes, grpThreads, allThreads, ...
    Latency, IdleTime, Connect);

% Append additional columns to the original table
JMeterTable = [samplesTable, auxTable];
JMeterTable = movevars(JMeterTable, 'success', 'After', 'dataType');

% Write the full table to a CSV file
writetable(JMeterTable, 'PerformanceTestResult.csv', 'QuoteStrings', true);

end