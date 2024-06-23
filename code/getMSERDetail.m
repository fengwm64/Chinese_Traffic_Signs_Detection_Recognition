function getMSERDetail(img,mserStats)
    if nargin == 1
        % 检测MSER（Maximally Stable Extremal Regions）区域
        [~, mserConnComp] = detectMSERFeatures(img, ...
            'RegionAreaRange', [30 150000], ...
            'ThresholdDelta', 5.5);  
        % 使用 regionprops 测量 MSER 区域的属性
         mserStats = regionprops(mserConnComp, 'BoundingBox', 'Area','Eccentricity', ...
            'Solidity', 'Extent', 'Euler', 'Image');
    end
    
    % 提取所有区域的边界框
    bboxes = vertcat(mserStats.BoundingBox);

    % 计算每个区域的偏心率、固实度、面积比、欧拉数
    eccentricity = [mserStats.Eccentricity];
    solidity = [mserStats.Solidity];
    extent = [mserStats.Extent];
    eulerNumber = [mserStats.EulerNumber];

    % 创建图像
    figure;
    imshow(img);
    hold on;

    for k = 1:length(mserStats)
        % 获取当前区域的边界框和属性
        bbox = bboxes(k, :);
        ecc = eccentricity(k);
        sol = solidity(k);
        ext = extent(k);
        euler = eulerNumber(k);

        % 在图像上绘制当前区域的边界框
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);

        % 标注当前区域的属性信息
        text(bbox(1), bbox(2) - 10, sprintf('Ecc: %.2f\nSolidity: %.2f\nExtent: %.2f\nEuler: %d', ecc, sol, ext, euler), ...
            'Color', 'r', 'FontSize', 8, 'FontWeight', 'bold');
    end

    hold off;
    title('MSER区域详细信息');
end

