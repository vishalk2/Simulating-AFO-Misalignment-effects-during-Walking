function data_range = getDataRange(motion,index,leg)
    if isequal(motion,1)
        default_dataRange = {'AX2:BA3101';'AX2:BA3101';
            'AX2:BA3101';'AX2:BA3101';
            'AX2:BA1351';'AX2:BA1337';
            'AX2:BA2378';'AX2:BA2378';
            'AX2:BA2465';'AX2:BA2656'};
        cell_range = cell2mat(default_dataRange(index));
    elseif isequal(motion,2)
        default_dataRange = {'AX2:BA562';'AX2:BA585';
            'AX2:BA514';'AX2:BA819';
            'AX2:BA606';'AX2:BA509';
            'AX2:BA524';'AX2:BA636';
            'AX2:BA494';'AX2:BA590'};
        cell_range = cell2mat(default_dataRange(index));
    elseif isequal(motion,3)
        default_dataRange = {'AX2:BA549';'AX2:BA489';
            'AX2:BA507';'AX2:BA536';
            'AX2:BA508';'AX2:BA479';
            'AX2:BA525';'AX2:BA522';
            'AX2:BA635';'AX2:BA529'};
        cell_range = cell2mat(default_dataRange(index));
    end
    
    % Data Range Selection for analysis
    range_type = questdlg(strcat('Type of Data Range to be used for-',leg,'-leg:'), ...
        'Data Range Selection', ...
        'New Data Range','Default Data Range','Default Data Range');

    switch range_type        
        case 'New Data Range'
            prompt = {'From Cell(AX) Number:';'To Cell(BA) Number:'};
            dlgtitle = 'New Data Range Selection';
            dims = [1,35];
            definput = {cell_range(3),cell_range(7:end)};
            range_input = inputdlg(prompt,dlgtitle,dims,definput);
            if isempty(range_input)
                disp('Proceeding with default data range')
                data_range = cell2mat(default_dataRange(index));
            else
                data_range = strcat('AX',cell2mat(range_input(1)), ...
                    ':BA',cell2mat(range_input(2)));
            end
        case 'Default Data Range'
            data_range = cell2mat(default_dataRange(index));
    end
end