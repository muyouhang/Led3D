import mxnet as mx
eps = 1e-10 + 1e-5
bn_mom = 0.9
fix_gamma = False
attr = {}
def conv_1x1(data,nnum_filter,name):
    data = mx.sym.Convolution(data=data, num_filter=nnum_filter, kernel=(1, 1), stride=(1, 1), pad=(0, 0),
                                  no_bias=True, name=name+'_conv_1', workspace=256)
    data = mx.sym.BatchNorm(data=data, fix_gamma=False, eps=2e-5, momentum=bn_mom, name=name+'_bn_1')
    data = mx.sym.Activation(data=data, act_type='relu', name=name+'_relu_1')
    return data
def conv_3x3(data,num_filter,name):
    conv1 = mx.sym.Convolution(data=data, num_filter=num_filter, kernel=(3, 3), stride=(1, 1), pad=(1, 1),no_bias=True, name=name+"_conv", workspace=256)
    bn1 = mx.sym.BatchNorm(data=conv1, fix_gamma=False, eps=2e-5, momentum=bn_mom, name=name+'_bn')
    relu1 = mx.sym.Activation(data=bn1, act_type='relu', name=name+'_relu')
    return relu1
def get_symbol(num_classes=509):
    data = mx.sym.var(name='data')
    # stage 1   128*128
    s1_relu1 = conv_3x3(data=data, num_filter=32, name='s1')
    s1_pool1 = mx.sym.Pooling(data=s1_relu1, kernel=(3, 3), stride=(2, 2), pad=(1, 1), pool_type='max')
    # stage 2   64*64
    s2_relu1 = conv_3x3(data=s1_pool1, num_filter=64, name='s2')
    s2_pool1 = mx.sym.Pooling(data=s2_relu1, kernel=(3, 3), stride=(2, 2), pad=(1, 1), pool_type='max', name='s2_pool')
    # stage 3    32*32
    s3_relu1 = conv_3x3(data=s2_pool1, num_filter=128, name='s3')
    s3_pool1 = mx.sym.Pooling(data=s3_relu1, kernel=(3, 3), stride=(2, 2), pad=(1, 1), pool_type='max', name='s3_pool')
    # stage 4    16*16
    s4_relu1 = conv_3x3(data=s3_pool1, num_filter=256, name='s4')
    s4_pool1 = mx.sym.Pooling(data=s4_relu1, kernel=(3, 3), stride=(2, 2), pad=(1, 1), pool_type='max', name='s4_pool')
    # stage 5    8*8
    s1_global_pool = mx.sym.Pooling(data=s1_relu1, kernel=(33, 33), stride=(16, 16), pad=(16, 16), pool_type='max',
                                    name="s1_global_pool")
    s2_global_pool = mx.sym.Pooling(data=s2_relu1, kernel=(17, 17), stride=(8, 8), pad=(8, 8), pool_type='max',
                                    name="s2_global_pool")
    s3_global_pool = mx.sym.Pooling(data=s3_relu1, kernel=(9, 9), stride=(4, 4), pad=(4, 4), pool_type='max',
                                    name="s3_global_pool")
    s4_global_pool = s4_pool1
    feature = mx.sym.concat(s1_global_pool, s2_global_pool, s3_global_pool, s4_global_pool, dim=1, name='feature')
    # stage 5    8*8
    s5_relu1 = conv_3x3(data=feature, num_filter=960, name='s5')
    s5_global_conv1 = mx.sym.Convolution(data=s5_relu1, kernel=(8, 8), stride=(8, 8), pad=(0, 0), num_filter=960,
                                  num_group=960, name="s5_global_conv")
    dr=mx.sym.Dropout(data=s5_global_conv1,p=0.2,name='drop')
    fc1 = mx.sym.FullyConnected(data=dr, num_hidden=num_classes, name='fc')
    return mx.sym.SoftmaxOutput(data=fc1, grad_scale=1, name='softmax')