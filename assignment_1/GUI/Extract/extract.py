import numpy as np
from PIL import Image, ImageTk
import tkinter as tk
from tkinter import ttk, messagebox
from tkinter import filedialog
import os

class ExtractGUI:
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.root = tk.Tk()
        
        self.root.geometry("360x500+1150+100")
        self.root.title("基于LSB的水印提取")
        try:
            self.root.iconbitmap(r"panda.ico")
        except:
            pass
        else:
            pass
        self.root.resizable(width=False, height=False)
        self.menu = tk.Menu(self.root)
        self.fileMenu = tk.Menu(self.menu, tearoff=False)
        self.fileMenu.add_command(label='打开载秘图片', command=self.choose_image_file)
        self.fileMenu.add_command(label='保存提取文件', command=self.save, state=tk.DISABLED)
        self.fileMenu.add_command(label='保存提取文件为', command=self.saveas, state=tk.DISABLED)
        self.fileMenu.add_separator()
        self.fileMenu.add_command(label='退出', command=self.exit)
        self.helpmenu = tk.Menu(self.menu, tearoff=False)
        self.helpmenu.add_command(label='联系作者', command=self.help)
        self.menu.add_cascade(label='文件(F)', menu=self.fileMenu)
        self.menu.add_cascade(label='帮助(H)', menu=self.helpmenu)
        self.root.config(menu=self.menu)
        self.imageButton = tk.Button(self.root, bitmap='gray50', text="click to selete file", height=300, width=300, compound=tk.LEFT, command=self.choose_image_file)
        self.imageButton.place(x=30, y=30)
        self.msgTypeLabel = tk.Label(self.root, text="水印类型:", width=13, height=1, anchor='e')
        self.msgTypeLabel.place(x=123, y=360)
        self.msgTypeLabel.place_forget()
        self.extractButton = tk.Button(self.root, text="提取", width=13, height=3, command=self.extract)
        self.extractButton.place(x=130, y=400)
        self.msgType = None

    def show_image(self, internalImage):
        zm = 300 / max(internalImage.size)
        resize = np.array(internalImage.size) * zm
        tkImage = ImageTk.PhotoImage(internalImage.resize(resize.astype(int)))
        self.imageButton.config(image=tkImage, compound='center', text='')
        self.imageButton.image = tkImage

    def choose_image_file(self):
        self.msgTypeLabel.place_forget()
        self.fileMenu.entryconfig(1, state = tk.DISABLED)
        self.fileMenu.entryconfig(2, state = tk.DISABLED)
        self.msgType = None
        self.imageFileName = filedialog.askopenfilename(filetypes=[('BMP', '.bmp')])
        self.image = Image.open(self.imageFileName)
        self.show_image(self.image)
        self.imageData = np.array(self.image)
        self.imageDataStream = self.imageData.flatten()
        dataHead = self.imageDataStream[:20 * 8]
        msgHeadData = np.zeros(20, dtype=np.int)
        try:
            for i, pixel in enumerate(dataHead):
                msgHeadData[i // 8] += (pixel % 2) << (i % 8)
            msgHead = bytes(list(msgHeadData)).decode()
            if msgHead == "msgTypestrmsgTypeEnd":
                self.msgType = '字符'
                self.msgTypeLabel.config(text="水印类型：字符")
                self.msgTypeLabel.place(x=123, y=360)
            elif msgHead == "msgTypefilmsgTypeEnd":
                self.msgType = '文件'
                self.msgTypeLabel.config(text="水印类型：文件")
                self.msgTypeLabel.place(x=123, y=360)
            else:
                self.msgTypeLabel.config(text="无法识别的水印")
                self.msgTypeLabel.place(x=123, y=360)
        except:
            messagebox.showinfo('提示', '无法识别的水印')
            return

    def get_info(self):
        msgHeadData = []
        msgHead = ""
        if self.msgType == '字符':
            index0 = -1
            index1 = -1
            for i, data in enumerate(self.imageDataStream[20 * 8:]):
                if i % 8 == 0:
                    msgHeadData.append(0)
                msgHeadData[i // 8] += (data % 2) << (i % 8)
                if (i % 8 == 0) and (i >= 8):
                    msgHead += bytes([msgHeadData[i // 8 - 1]]).decode()
                    if (len(msgHead) >= 10):
                        if index0 == -1:
                            index0 = msgHead.find("len")
                        if index1 == -1:
                            index1 = msgHead.find("lenEnd")
                        if (index0 != -1) and (index1 != -1):
                            break
            if (index0 != -1) and (index1 != -1):
                self.msgDataLen = int(msgHead[index0 + 3:index1])
                self.start = index1 + 26
        elif self.msgType == '文件':
            index0 = -1
            index1 = -1
            index2 = -1
            index3 = -1
            for i, data in enumerate(self.imageDataStream[20 * 8:]):
                if i % 8 == 0:
                    msgHeadData.append(0)
                msgHeadData[i // 8] += (data % 2) << (i % 8)
                if (i % 8 == 0) and (i >= 8):
                    msgHead += bytes([msgHeadData[i // 8 - 1]]).decode()
                    if (len(msgHead) >= 10):
                        if index0 == -1:
                            index0 = msgHead.find("fileName")
                        if index1 == -1:
                            index1 = msgHead.find("fileNameEnd")
                        if index2 == -1:
                            index2 = msgHead.find("len")
                        if index3 == -1:
                            index3 = msgHead.find("lenEnd")
                        if (index0 != -1) and (index1 != -1) and (index2 != -1) and (index3 != -1):
                            break
            if (index0 != -1) and (index1 != -1) and (index2 != -1) and (index3 != -1):     
                self.msgFileName = msgHead[index0 + 8:index1]      
                self.msgDataLen = int(msgHead[index2 + 3:index3])
                self.start = index3 + 26

    def extract(self):
        try:
            self.imageDataStream
        except:
            messagebox.showinfo('提示', '请选择载秘文件')
            return
        if self.msgType == None:
            messagebox.showinfo('提示', '无法识别水印类型')
            return
        try:
            self.get_info()
        except:
            messagebox.showinfo('提示', '读取水印信息错误')
            return
        print(self.start)
        dataStream = self.imageDataStream[self.start * 8:]
        msgDec = []
        for i, data in enumerate(dataStream):
            print(i)
            if i >= self.msgDataLen * 8:
                break
            if i % 8 == 0:
                msgDec.append(0)
            msgDec[i // 8] += (data % 2) << (i % 8)
        self.msgData = bytes(msgDec)
        if self.msgType == '字符':
            messagebox.showinfo('水印内容为', self.msgData.decode())
            return
        elif self.msgType == '文件':
            messagebox.showinfo('提醒', "提取成功，请点击文件保存")
            self.fileMenu.entryconfig(1, state = tk.ACTIVE)
            self.fileMenu.entryconfig(2, state = tk.ACTIVE)
            return
            
    def save(self):
        try:
            fileName = os.path.dirname(self.imageFileName) + '/' + self.msgFileName
            print(fileName)
            with open(fileName, 'wb') as fp:
                fp.write(self.msgData)
        except:
            messagebox.showinfo('提示', '保存失败')
            return

    def saveas(self):
        try:
            index = self.msgFileName.rfind('.')
            ex = self.msgFileName[index:]
            fileName = filedialog.asksaveasfilename(filetypes=[('DAMN', ex)], defaultextension=ex)
            print(fileName)
            with open(fileName, 'wb') as fp:
                fp.write(self.msgData)
        except:
            messagebox.showinfo('提示', '保存失败')
            return

    def exit(self):
        self.root.quit()
            
    def help(self):
        messagebox.showinfo('提示', '作者邮箱:minzhp@foxmail.com')
        return

if __name__ == "__main__":
    gui = ExtractGUI()
    gui.root.mainloop()
