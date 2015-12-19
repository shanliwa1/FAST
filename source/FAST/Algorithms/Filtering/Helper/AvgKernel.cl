__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;


__kernel void CutExcess(
    __read_only image2d_t input,
    __read_only image2d_t inputOne,
    __write_only image2d_t output,
    float maxVal,
    float maxValOne,
    float minVal,
    float minValOne)
{
    const int2 pos = { get_global_id(0), get_global_id(1) };

    float value;
    int dataType = get_image_channel_data_type(input);
    if (dataType == CLK_FLOAT) {
        value = read_imagef(input, sampler, pos).x;
    }
    else if (dataType == CLK_UNSIGNED_INT8 || dataType == CLK_UNSIGNED_INT16) {
        value = read_imageui(input, sampler, pos).x;
    }
    else {
        value = read_imagei(input, sampler, pos).x;
    }

    float valueOne;
    int dataTypeOne = get_image_channel_data_type(inputOne);
    if (dataTypeOne == CLK_FLOAT) {
        valueOne = read_imagef(inputOne, sampler, pos).x;
    }
    else if (dataTypeOne == CLK_UNSIGNED_INT8 || dataTypeOne == CLK_UNSIGNED_INT16) {
        valueOne = read_imageui(inputOne, sampler, pos).x;
    }
    else {
        valueOne = read_imagei(inputOne, sampler, pos).x;
    }

    //value = (value + valueOne)/2; 
    //if (fabs(valueOne - 0.5) > fabs(value - 0.5)){ //if valueOne more distinct
    //    value = valueOne;
    //}
    //value = sqrt((value - 0.5)*(value - 0.5) + (valueOne - 0.5)*(valueOne - 0.5)); //or -0.5f if normalized
    //Scale values to minVal
    //value = value - minVal;
    //valueOne = value - minVal;
    //maxVal = maxVal - minVal;
    //maxValOne = maxVal - minVal;
    //maxVal = max(maxVal, -minVal);
    //maxValOne = max(maxValOne, -minValOne);
    //if (fabs(minVal) > maxVal) maxVal = fabs(minVal);
    //if (fabs(minValOne) > maxValOne) maxValOne = fabs(minValOne);
    //value = fabs(value);
    //valueOne = fabs(valueOne);
    //Scale values to maxVal
    value = fabs(value)  / maxVal; //need no fabs?
    valueOne = fabs(valueOne) / maxValOne;
    // Calculate total magnitude
    value = sqrt(value*value + valueOne*valueOne); //was no /2

    //Scale?
    if (CUT_OVERHEAD){
        if (value > MAX_VAL){
            value = MAX_VAL;
        }
        else if (value < MIN_VAL){
            value = MIN_VAL;
        }
    }

    int outputDataType = get_image_channel_data_type(output);
    if (outputDataType == CLK_FLOAT) {
        write_imagef(output, pos, value);
    }
    else if (outputDataType == CLK_UNSIGNED_INT8 || outputDataType == CLK_UNSIGNED_INT16) {
        write_imageui(output, pos, round(value));
    }
    else {
        write_imagei(output, pos, round(value));
    }
}