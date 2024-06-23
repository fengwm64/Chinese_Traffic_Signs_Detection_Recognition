function detectRecTrafficSigns(data_path, classifier, class_name)
    % 获取所有图像文件列表
    img_list = dir(fullfile(data_path, '*.jpg'));

    for i = 1:length(img_list)        
        file_name = img_list(i).name;
        disp(['Predicting for ', file_name]); % 打印当前正在处理的文件名
        
        % 获取图像路径并读取图像
        image_path = fullfile(data_path, file_name);
        img = imread(image_path); 

        % 定位标志
        [~, signs] = Detection(img);
        
        % 调整图像大小
        resize_signs = cell(size(signs));
        sign_num = size(resize_signs,2);
        [predictedLabels, resize_signs] = Recognition(signs, class_name, classifier);
        
        % 可视化
        figure
        subplot(1,sign_num+1,1)
        imshow(imresize(img, [256 256]))
        title("原始图像")
        for k = 1:sign_num
            subplot(1,sign_num+1,k+1)
            imshow(resize_signs{k})
            title(predictedLabels{k})
        end
    end
end
