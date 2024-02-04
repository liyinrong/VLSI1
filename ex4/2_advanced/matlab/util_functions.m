function message = util_functions
    assignin('caller', 'saturate', @saturate);
    assignin('caller', 'save_png', @save_png);
    assignin('caller', 'png2ascii', @png2ascii);
    assignin('caller', 'ascii2png', @ascii2png);
end

function sat_pic = saturate(file_name, scale)
    % Return a saturated image (as matrix) of the input image with the given filename.
    pic = imread(file_name);

    apic = pic;
    pic32 = uint32(apic);
    RWEIGHT = uint32(74);
    GWEIGHT = uint32(145);
    BWEIGHT = uint32(36);

    gray_scale_pic = pic32(:, :, 1) * RWEIGHT + pic32(:, :, 2) * GWEIGHT + pic32(:, :, 3) * BWEIGHT;
    gray_scale_pic = uint32(floor(double(gray_scale_pic)/256));
    gray_scale_pic = uint8(gray_scale_pic);

    pics16 = int16(apic);
    gray_scale_pic_s16 = int16(gray_scale_pic);

    r_delta = pics16(:, :, 1) - gray_scale_pic_s16;
    g_delta = pics16(:, :, 2) - gray_scale_pic_s16;
    b_delta = pics16(:, :, 3) - gray_scale_pic_s16;

    r_delta = r_delta * scale + gray_scale_pic_s16;
    g_delta = g_delta * scale + gray_scale_pic_s16;
    b_delta = b_delta * scale + gray_scale_pic_s16;

    sat_pic = pic;
    sat_pic(:, :, 1) = uint8(r_delta);
    sat_pic(:, :, 2) = uint8(g_delta);
    sat_pic(:, :, 3) = uint8(b_delta);
end

function png2ascii(in_file_name)
    % Save a comma-separated ASCII (.txt) version of a PNG file using the same file name.
    pic = imread(in_file_name);
    unrolled_pic = reshape(pic(:, :, 1).', 1, [])';
    unrolled_pic = [unrolled_pic, reshape(pic(:, :, 2).', 1, [])'];
    unrolled_pic = [unrolled_pic, reshape(pic(:, :, 3).', 1, [])'];
    text_file = strrep(in_file_name, '.png', '.txt') ;
    csvwrite(text_file, unrolled_pic);
end

function ascii2png(in_file_name, ref_png)
    % Save a PNG version of an input ASCII file using the same file name.
    % `ref_png` is a PNG file with the same dimensions that the output PNG is expected to have.
    ref_png = imread(ref_png);
    size_dims = size(ref_png);
    unrolled_pic = uint8(csvread(in_file_name));
    png_file = strrep(in_file_name, '.txt', '.png') ;
    unrolled_pic_padded = zeros(size_dims(2)*size_dims(1), 3, 'uint8');
    unrolled_pic_padded(1:length(unrolled_pic), :) = [unrolled_pic(:,1),unrolled_pic(:,2),unrolled_pic(:,3)];
    rolled_pic_padded = reshape(unrolled_pic_padded, [size_dims(2) size_dims(1) size_dims(3)]) ;
    rolled_pic_padded = permute(rolled_pic_padded, [2 1 3]);
    imwrite(rolled_pic_padded, png_file);
end

function save_png(mat_in, file_name)
    % For an image in matrix form, create the corresponding PNG file and save it under the given
    % filename.
    imwrite(mat_in, file_name);
end
