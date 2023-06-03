import tkinter as tk
from sys import argv


def resize_text():
    # Get the current window size
    window_width = root.winfo_width()
    window_height = root.winfo_height()

    if window_width > 50 and window_height > 50:
        textWidget.configure(
            font=('Victor Mono', min(window_width, window_height) // 20)
        )
    else:
        textWidget.configure(font=('Victor Mono', 5))


# Create the main window
root = tk.Tk()
root.title('to-do')
root.geometry('200x100')  # Initial window size

# Create a label to display the text
text = ''
for i in argv[1:]:
    text = f'{text}\n{i}'

textWidget = tk.Text(root, font=('Arial', 12), wrap=tk.WORD)
textWidget.insert(tk.END, text)
textWidget.pack(fill=tk.BOTH, expand=False)

# Bind the resize event to the text resizing function
root.bind('<Configure>', lambda event: resize_text())

# Start the GUI event loop
root.mainloop()
