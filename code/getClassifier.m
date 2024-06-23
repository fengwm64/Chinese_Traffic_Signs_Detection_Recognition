function [classifier] = getClassifier(data_path, class_name)
    % 创建数据集，不划分测试集
    disp("====================================")
    disp("============= 创建数据集 ===========")
    disp("====================================")
    [train_features, train_labels, ~, ~] = createDataSet(class_name, data_path, 0);
    % 训练SVM分类器
    disp("====================================")
    disp("============ 训练SVM分类器 =========")
    disp("====================================")
    tic
    classifier = fitcecoc(train_features,train_labels);
    toc
    disp("Done!")
end

