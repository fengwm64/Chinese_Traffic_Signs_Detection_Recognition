function [predictedLabels,resize_signs] = Recognition(signs, class_name, classifier)
    % 标志数量
    sign_num = numel(signs);
    
    % 预分配cell数组以存储调整大小后的图像
    resize_signs = cell(1, sign_num);
    
    % 预分配cell数组以存储预测标签
    predictedLabels = cell(1, sign_num);
    
    for j = 1:sign_num
        % 读取当前的标志图像
        sign_image = signs{j};
        
        % 检查sign_image是否为空
        if isempty(sign_image)
            warning('Empty sign image at index %d', j);
            continue;
        end

        % 调整图像大小
        resize_signs{j} = imresize(sign_image, [256 256]);
    
        % 提取HOG特征并进行识别
        test_features = extractHOGFeatures(resize_signs{j}, 'CellSize', [5 5]);
        
        % 进行分类并获取标签
        label_index = predict(classifier, test_features);
        
        % 检查label_index是否在有效范围内
        if label_index > 0 && label_index <= numel(class_name)
            predictedLabels{j} = class_name{label_index};
        else
            warning('Invalid label index predicted for sign %d', j);
            predictedLabels{j} = 'Unknown';
        end
    end
end
