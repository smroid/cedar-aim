use image::GrayImage;

fn compute_lut(peak_pixel_value: u8, gamma: f32) -> [u8; 256] {
    let mut lut: [u8; 256] = [0; 256];
    let scale = 256.0 / (peak_pixel_value as f32).powf(gamma);
    for n in 0..256 {
        let mapped = scale * (n as f32).powf(gamma);
        let clamped = if mapped >= 255.0 {
            255_u8
        } else {
            mapped as u8
        };
        lut[n] = clamped;
    }
    lut
}

// Copy the image, mapping 0..peak_pixel_value to 0..255 by applying a
// gamma and scale factor.
pub fn scale_image(image: &GrayImage, peak_pixel_value: u8, gamma: f32)
                   -> GrayImage {
    let lut = compute_lut(peak_pixel_value, gamma);

    // Apply the lut
    let out_vec: Vec<u8> = image.as_raw().iter().map(|x| lut[*x as usize]).collect();

    let (width, height) = image.dimensions();
    GrayImage::from_raw(width, height, out_vec).unwrap()
}

// In-place variant of scale_image().
pub fn scale_image_mut(image: &mut GrayImage, peak_pixel_value: u8, gamma: f32) {
    let lut = compute_lut(peak_pixel_value, gamma);

    for pixel in image.pixels_mut() {
        pixel[0] = lut[pixel[0] as usize];
    }
}
