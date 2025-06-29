import matplotlib.pyplot as plt
import math
import numpy as np

def binary_to_fixed_point(bin_str,n):
    """Convert a 64-bit binary string to fixed-point float where first bit is 0.5."""
    value = 0.0
    for i, bit in enumerate(bin_str.strip()):
        if bit == '1':
            #if (i!=0) :
             value += 2**(n) / (2 ** (i-1))
    return value

def read_and_convert(filename,n):
    values = []
    with open(filename, 'r') as file:
        for line in file:
            if len(line.strip()) != 64:
                continue  # skip invalid lines
            value = binary_to_fixed_point(line,n)
            values.append(value)
    return values

def plot_values(x,values1,values2,ch):
    plt.figure(figsize=(10, 5))
    plt.plot(x,values1,label='codec',color='blue')
    plt.plot(x,values2,label='actual',color='green')
    plt.legend()
    plt.title('Fixed-Point Binary Values')
    plt.xlabel('Sample Index')
    plt.ylabel(ch)
    plt.grid(True)
    plt.show() 
    

# ==== USAGE ====
filename1 = "outputcos.txt"  # Replace with your filename
filename2 = "outputsin.txt"
filename3 = "outputcosh.txt"
filename4 = "outputsinh.txt"
filename5 = "outputatan.txt"
filename6 = "outputatanh.txt"
filename8 = "outputlnx.txt"
data1 = read_and_convert(filename1,0)
data2 = read_and_convert(filename2,0)
data3 = read_and_convert(filename3,8)
data4 = read_and_convert(filename4,8) 
data5 = read_and_convert(filename5,0)
data6 = read_and_convert(filename6,6)
data8 = read_and_convert(filename8,7)
xh=np.arange(0,5,0.002)
x=np.arange(0,math.pi/2,0.001)
x1=[]
for j in range(x.size):
    x1.append(x[j])
ycos=[] 
ysin=[]
for i in range( 1571) :
  ycos.append(math.cos(x[i]))
for i in range( 1571) :
  ysin.append(math.sin(x[i]))
ycosh=[] 
ysinh=[]
for i in range( 2500) :
  ycosh.append(math.cosh(xh[i]))
for i in range( 2500) :
  ysinh.append(math.sinh(xh[i]))
ye_x=[]  
data7=np.add(data3,data4) 
for i in range( 2500) :
  ye_x.append(math.exp(xh[i]))
xatan=[]
for i in range (x.size):
  xatan.append(math.tan(x[i]))  
yatanh=np.arange(0,1,0.001)  
xatanh=[] 
for i in range (yatanh.size-1):
  xatanh.append(math.tanh(yatanh[i]))
x_ln=np.arange(1,10,0.01)
ylnx=[] 
for i in range (x_ln.size-1):
  ylnx.append(math.log(x_ln[i]))

#plot_values(x1,data1,ycos,"cos(x)")
#plot_values(x1,data2,ysin,"sin(x)")
#plot_values(xh[0:600],data3[0:600],ycosh[0:600],"cosh(x)")
#plot_values(xh[0:600],data4[0:600],ysinh[0:600],"sinh(x)")
plot_values(xh[0:600],data7[0:600],ye_x[0:600],"e^(x)")
#plot_values(xatan,data5,x,"atan(x)")
#plot_values(xatanh,data6,yatanh[0:999],"atanh(x)")
#plot_values(x_ln[0:899],data8,ylnx[0:899],"ln(x)")
 
