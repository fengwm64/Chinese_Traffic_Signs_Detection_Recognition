function [train_features, train_labels, test_features, test_labels] = createDataSet(class_name, data_path, testSet)
    % 预分配内存
    max_num_images = 0;
    for index = 1:length(class_name)
        class_data = fullfile(data_path, class_name{index});
        img_list = dir(class_data);
        img_list = img_list(~ismember({img_list.name}, {'.', '..'}));
        max_num_images = max_num_images + length(img_list);
    end

    % 计算特征向量的长度
    image_path = fullfile(class_data, img_list(1).name);
    image = imread(image_path);
    resize_image = imresize(image, [256 256]);
    hog_features = extractHOGFeatures(resize_image, 'CellSize', [5 5]);
    len = size(hog_features, 2);

    train_features = zeros(max_num_images, len);
    train_labels = zeros(max_num_images, 1);
    test_features = zeros(max_num_images, len);
    test_labels = zeros(max_num_images, 1);
    
    train_idx = 0;
    test_idx = 0;
    
    % 训练部分
    for index = 1:length(class_name)
        disp(['Processing class -- ', class_name{index}]);
    
        class_data = fullfile(data_path, class_name{index});
        img_list = dir(class_data);
        img_list = img_list(~ismember({img_list.name}, {'.', '..'}));
        
        current_labels = index * ones(size(img_list, 1), 1);
        
        % 计算当前类别中用作测试集的图像数量
        num_images = length(img_list);
        num_test_images = floor(testSet * num_images);
        
        % 随机选择测试集图像的索引
        test_indices = randsample(num_images, num_test_images);
    
        for i = 1:length(img_list)
            % 获取图像路径并读取图像
            image_path = fullfile(class_data, img_list(i).name);
            image = imread(image_path);
    
            % 调整图像大小
            resize_image = imresize(image, [256 256]);
    
            % 提取HOG特征
            hog_features = extractHOGFeatures(resize_image, 'CellSize', [5 5]);
    
            % 决定是添加到训练集还是测试集
            if any(i == test_indices)
                % 添加到测试集
                test_idx = test_idx + 1;
                test_features(test_idx, :) = hog_features;
                test_labels(test_idx) = current_labels(i);
            else
                % 添加到训练集
                train_idx = train_idx + 1;
                train_features(train_idx, :) = hog_features;
                train_labels(train_idx) = current_labels(i);
            end
        end
    end
    
    % 截取实际使用的部分（可能有未使用的预分配空间）
    train_features = train_features(1:train_idx, :);
    train_labels = train_labels(1:train_idx);
    test_features = test_features(1:test_idx, :);
    test_labels = test_labels(1:test_idx);
end
