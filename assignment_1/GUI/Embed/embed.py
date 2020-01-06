import numpy as np
from PIL import Image, ImageTk
import tkinter as tk
from tkinter import ttk, messagebox
from tkinter import filedialog
import os

class EmbedGUI:
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.root = tk.Tk()
        self.root.geometry("600x380+1150+100")
        self.root.title("基于LSB的水印嵌入")
        try:
            self.root.iconbitmap(r"panda.ico")
        except:
            pass
        else:
            pass
        self.root.resizable(width=False, height=False)
        self.menu = tk.Menu(self.root)
        filemenu = tk.Menu(self.menu, tearoff=False)
        filemenu.add_command(label='保存载秘图片', command=self.save)
        filemenu.add_command(label='保存载秘图片为', command=self.saveas)
        filemenu.add_separator()
        filemenu.add_command(label='退出', command=self.exit)
        helpmenu = tk.Menu(self.menu, tearoff=False)
        helpmenu.add_command(label='联系作者', command=self.help)
        self.menu.add_cascade(label='文件(F)', menu=filemenu)
        self.menu.add_cascade(label='帮助(H)', menu=helpmenu)
        self.root.config(menu=self.menu)
        self.carrierButton = tk.Button(self.root, bitmap='gray50', text="click to selete file", height=300, width=300, compound=tk.LEFT, command=self.choose_carrier_file)
        self.carrierButton.place(x=30, y=30)
        self.msgTypeLabel = tk.Label(self.root, text="水印类型:", width=8, height=1, anchor='e')
        self.msgTypeLabel.place(x=380, y=30)
        self.msgTypeCombobox = ttk.Combobox(self.root, state='readonly', width=6, height=1)
        self.msgTypeCombobox.place(x=450, y=30)
        self.msgTypeCombobox['values'] = ['字符', '文件']
        self.msgTypeCombobox.current(0)
        self.msgTypeCombobox.bind("<<ComboboxSelected>>", self.choose_mag_type)
        self.msgContentLabel = tk.Label(self.root, text="水印内容:", width=8, height=1, anchor='e')
        self.msgContentLabel.place(x=380, y=90)
        self.msgEntry = tk.Entry(self.root, width=20, font=('StSong', 18))
        self.msgEntry.place(x=360, y=120)
        self.msgButton = tk.Button(self.root, text="请选择要嵌入的文件", width=18, height=1, command=self.choose_msg_file)
        self.msgButton.place(x=400, y=110)
        self.msgButton.place_forget()
        self.embedButton = tk.Button(self.root, text="嵌入", width=13, height=5, command=self.embed)
        self.embedButton.place(x=420, y=200)
        self.msgType = '字符'
        
    def show_image(self, internalImage):
        zm = 300 / max(internalImage.size)
        resize = np.array(internalImage.size) * zm
        tkImage = ImageTk.PhotoImage(internalImage.resize(resize.astype(int)))
        self.carrierButton.config(image=tkImage, compound='center', text='')
        self.carrierButton.image = tkImage

    def choose_carrier_file(self):
        self.carrierFileName = filedialog.askopenfilename(filetypes=[('BMP', '.bmp'), ('JPEG', '.jpg'), ('PNG', '.png')])
        self.carrierImage = Image.open(self.carrierFileName)
        self.show_image(self.carrierImage)
        self.carrierImageData = np.array(self.carrierImage)

    def choose_mag_type(self, *args):
        self.msgType = self.msgTypeCombobox.get()
        if self.msgType == '字符':
            self.msgButton.place_forget()
            self.msgContentLabel.place(x=380, y=90)
            self.msgEntry.place(x=360, y=120)
        elif self.msgType == '文件':
            self.msgContentLabel.place_forget()
            self.msgEntry.place_forget()
            self.msgButton.place(x=400, y=110)

    def choose_msg_file(self):
        self.msgFileName = filedialog.askopenfilename()
        if not len(self.msgFileName) == 0: 
            self.msgButton.config(text='已选择嵌入文件')

    def data_process(self):
        try:
            self.carrierImageDataLen = self.carrierImageData.size
        except:
            messagebox.showinfo('提示', '请选择载体文件')
            return False
        if self.msgType == '字符':
            msg = self.msgEntry.get()
            if len(msg) == 0:
                messagebox.showinfo('提示', '请输入水印内容')
                return False
            else:
                self.msgDataLen = len(msg)
                msgHead = "msgTypestrmsgTypeEnd" + f"len{self.msgDataLen}lenEnd"
                print(msgHead)
                self.msgData = msgHead.encode() + msg.encode()
                if (len(self.msgData) * 8) > self.carrierImageDataLen:
                    messagebox.showinfo('提示', '水印内容过长')
                    return False
                else:
                    self.carrierImageDataStream = self.carrierImageData.flatten()
                    self.imageDataStream = self.carrierImageData.flatten()
        elif self.msgType == '文件':
            try:
                with open(self.msgFileName, 'rb') as file:
                    msg = file.read()
            except:
                messagebox.showinfo('提示', '请选择要嵌入的文件')
                return False
            fileName = os.path.basename(self.msgFileName)
            
            self.msgDataLen = len(msg)
            msgHead = "msgTypefilmsgTypeEnd" + f"fileName{fileName}fileNameEnd" + f"len{self.msgDataLen}lenEnd"
            self.msgData = msgHead.encode() + msg
            if (len(self.msgData) * 8) > self.carrierImageDataLen:
                messagebox.showinfo('提示', '文件过大')
                return False
            else:
                self.carrierImageDataStream = self.carrierImageData.flatten()
                self.imageDataStream = self.carrierImageData.flatten()
        return True

    def embed(self):
        if self.data_process():
            for i, pixel in enumerate(self.carrierImageDataStream):
                if i >= (len(self.msgData) * 8):
                    break
                self.imageDataStream[i] = pixel - (pixel % 2) + ((self.msgData[int(i // 8)] >> (i % 8)) & 1)
            self.image = Image.fromarray(self.imageDataStream.reshape(self.carrierImageData.shape))
            self.show_image(self.image)
            messagebox.showinfo('提示', '嵌入成功')
            
    def save(self):
        try:
            self.fileName = self.carrierFileName[:-4] + "_CM.bmp"
            self.image.save(self.fileName, 'bmp')
        except:
            messagebox.showinfo('提示', '载秘图片不存在')
            return

    def saveas(self):
        try:
            self.fileName = filedialog.asksaveasfilename(filetypes=[('BMP', '.bmp')], defaultextension='.bmp')
            self.image.save(self.fileName, 'bmp')
        except:
            messagebox.showinfo('提示', '载秘图片不存在')
            return

    def exit(self):
        self.root.quit()
            
    def help(self):
        messagebox.showinfo('提示', '作者邮箱:minzhp@foxmail.com')
        return

if __name__ == "__main__":
    gui = EmbedGUI()
    gui.root.mainloop()
