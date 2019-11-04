# -*- coding:utf-8 -*-
import cv2
import mxnet as mx
import numpy as np
from collections import namedtuple
from sklearn.metrics.pairwise import cosine_similarity

Batch= namedtuple('Batch', ['data'])
def get_image(image_path):
    img=cv2.imread(image_path)
    if img is None:
        return None
    img = np.swapaxes(img, 0, 2)
    img = np.swapaxes(img, 1, 2)
    img = img[np.newaxis, :]
    return img
def load_mod():
    sym, arg_params, aux_params = mx.model.load_checkpoint('./param/led3d',0)
    internals = sym.get_internals()
    fc1 = internals['s5_global_conv_output']
    group = mx.symbol.Group([fc1, sym])
    mod = mx.mod.Module(symbol=group,context=ctx)
    mod.bind(for_training=False,data_shapes=[('data',(1,3,128,128))])
    mod.set_params(arg_params,aux_params)
    return mod
def extract_feature(path):
    image = get_image(path)
    mod.forward(Batch([mx.nd.array(image)]))
    mod_out = mod.get_outputs()[0].asnumpy()
    feature=np.squeeze(mod_out)
    return feature
if __name__ == '__main__':
    ctx=mx.cpu(0)
    mod=load_mod()
    g = extract_feature('./data/gallery/2/003_Kinect_NU_1DEPTH_1.jpg')
    p = extract_feature('./data/probe/2/003_Kinect_NU_2DEPTH_29.jpg')
    sim = cosine_similarity([g],[p])
    print(sim)