function ps35 = initialize_owis()

usb = seriallist; % Returns list of all the serial ports connected on the PC

if length(usb) == 1 % If there is only one serial port connected
    disp(usb)
else % If there is more than one serial port connected, choose the one to use
    disp(usb)
    disp("Multiple usb connected.")
    disp("COM1 doesn't correspond to Owis on the Vantage system")
    prompt = 'Choose the COM to use : type the corresponding number.\n';
    num = input(prompt);
    
    while length(usb)>1
        
        for i = 1:length(usb)
            com = convertStringsToChars(usb(i));
            if num == str2num(com(end)); usb = usb(i); disp(usb); end
        end
        
        if length(usb)>1; num = input('The COM is not connected, choose another one from the list.\n'); end
        
    end
end


%     instrreset;
ps35 = serial(usb,'Baudrate',9600,'Terminator','CR');
fopen(ps35);

disp('Owis platform ready to be used.');
end