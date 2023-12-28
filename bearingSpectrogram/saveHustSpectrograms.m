function saveHustSpectrograms(signalDir, spectrogramDir)
    downloadTo(signalDir);

    signalFiles = listHustDir(signalDir);
    samplingFreq = 51200;
    
    for i = 1:length(signalFiles)
        [~, fileName, ~] = fileparts(signalFiles(i));
        fprintf("Processing: %s.mat\n", fileName);
        
        [signal, shaftFreq] = loadSignal(signalFiles(i));
        segmentLength = ceilDiv(samplingFreq, shaftFreq);
        saveDir = fullfile(spectrogramDir, fileName);
        saveSpectrograms(signal, segmentLength, saveDir);
    end
end


function downloadTo(signalDir)
    downloadUrl = "https://prod-dcd-datasets-cache-zipfiles.s3.eu-west-1.amazonaws.com/cbv7jyx4p9-3.zip";
    downloadFile = "HUST bearing a practical dataset for ball bearing fault diagnosis.zip";
    extractDir = "HUST bearing a practical dataset for ball bearing fault diagnosis";

    if ~isfolder(extractDir)
        return
    end

    websave(downloadFile, downloadUrl);
    unzip(downloadFile);
    movefile(fullfile(extractDir, "HUST bearing dataset"), signalDir);
    delete(downloadFile);
    rmdir(extractDir, "s");
end



function files = listHustDir(signalDir)
    files = listDir(fullfile(signalDir, "*.mat"));
end


function [signal, shaftFreq] = loadSignal(dataFilePath)
    data = load(dataFilePath);
    signal = data.data;
    shaftFreq = data.fs;
end