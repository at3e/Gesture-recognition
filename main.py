import keras.backend as K
from keras.models import Model
from keras.layers import Input, Masking, Flatten
from keras.layers.core import Dense
from keras.optimizers import adagrad,adam
from keras import utils as Kutil
from keras import regularizers as regl
import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt
import h5py
np.random.seed()

# load data

Data = sio.loadmat('.\Data\TestDataSet.mat',matlab_compatible = True)

Data.keys()
folds = Data['DataSet']
Testfolds = Data['TestDataSet']

num_folds = 6
dim_1 = 64
dim_2 = 2
batch_sz = 1
num_samp = 80

def train_batch_generator(Data,batch_id):            
    SeqFiles = Data[batch_id] 
    num = num_samp
    
    perm = np.random.permutation(np.arange(num)) 
    X = SeqFiles[0]
    y = SeqFiles[1] 
    Xbatch = []
    yLabel = []
    for k in range (int(num)):    
        Xbatch.append(X[int(perm[k])][0])
        yLabel.append(y[int(perm[k])])   
    
    yLabel = np.asarray(yLabel)        
    return Xbatch,yLabel    

def test_generator(Data,fold):
    test_id = fold   
    TestSeqs = Data[test_id]
    
    Xtest = TestSeqs[0]
    ytestLabel = TestSeqs[1]
    
    return Xtest, ytestLabel

def classifier_model():
    
    # model specification
    
    nd_classes = 10
    batch_size = 1
    dropout = 0
    units_1 = 30
    units_2 = 20
    
    inp = Input(shape = (dim_1,dim_2),batch_shape = (10,dim_1,dim_2),name = 'input_layer')
    
#    mask_layer = Masking(mask_value = 0, input_shape = (dim_1,dim_2),
#                         batch_input_shape = (batch_sz,dim_1,dim_2), 
#                         name = 'mask_layer')(inp)
    
    L1 = Dense(units_1, activation='relu', use_bias=True, 
                    kernel_initializer='glorot_uniform', bias_initializer='zeros',
                    kernel_regularizer=regl.l2(0.01), name = 'Dense_1')(inp) 
   
    L2 = Dense(units_2, activation='relu', use_bias=True, 
                    kernel_initializer='glorot_uniform', bias_initializer='zeros',
                    kernel_regularizer=None, name = 'Dense_2')(Dense_1)
    
    L2 = Flatten()(L2)
    out = Dense(nd_classes, activation ='sigmoid', name = 'output_layer')(Dense_2)
    
    model = Model(inputs=inp, outputs= out)
   
    model.summary()
    
    return model 

Classifier_Model = classifier_model()
    
#compile the model
adagrad_optim = adagrad(lr=0.02)
Classifier_Model.compile(loss="categorical_crossentropy", optimizer=adagrad_optim,
              metrics=["accuracy","mae"])

#Classifier_Model.load_weights('.\Data\Weights.h5')
#train model

minibatch_sz = 1
num_class = 10
nepoch = 200

perf = []
for nfold in range (num_folds):
    num_batches = 5
    nf = (nfold+3)%num_folds
    ran = np.random.permutation(num_folds)
    testfold = np.where(ran==nf)
    ran = np.delete(ran,testfold[0][0]) 
    
    for epoch in range(nepoch):
        #print(str(epoch))
        
        for bid in range(num_batches):
            batch_id = ran[bid]
            Xbatch = train_batch_generator(folds,batch_id)
            ybatch = Xbatch[1]
            Xbatch = np.reshape(Xbatch[0],(80,64,2))
            
            yLabel = Kutil.to_categorical(np.subtract(ybatch,1),num_classes=num_class)
               
            Hist = Classifier_Model.fit(Xbatch, yLabel,epochs=1, verbose=0, batch_size=10)
                                
    
                   
    Xtest = test_generator(Testfolds,nf)
    ytest = Xtest[1]
    Xtest = np.reshape(Xtest[0],(80,64,2))
    
    ytest = Kutil.to_categorical(np.subtract(ytest,1),num_classes=num_class)
        
    ScoreTest = Classifier_Model.evaluate(Xtest,ytest,batch_size=10,verbose=0)
        
    print(ScoreTest[1])
    
    perf.append(ScoreTest[1])       

print(sum(perf)/6)    
#    
#    for i in range(80):
#        xcurr = Xtest[i][0]
#        xcurr = xcurr[np.newaxis,:,:]
#
#        currLabel = Kutil.to_categorical(np.subtract(ytest[i],1),num_classes=num_class)       
#    
#        ScoreTest = Classifier_Model.evaluate(xcurr,currLabel,verbose=0)
#        
#        perf.append(ScoreTest[1])
#        
#    print(str(sum(perf)/80))    
#        
#
