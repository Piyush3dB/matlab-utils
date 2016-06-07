classdef DigitalFilter
    properties
        b;
        a;
        
        h;
        s;
        t;
        f;
        w;
        
        gd;
        hz;
        hp;
        ht;
        
    end
    
    methods
        
        function obj = DigitalFilter(b,a)
            
            N = 1000;
            
            % Coefficients
            obj.b = b;
            obj.a = a;
            
            % Impulse response
            [obj.h, obj.t] = impz(b, a, N);
            
            % Step Response
            [obj.s, obj.t] = stepz(b, a, N);
            
            % Frequency Response
            [obj.f, obj.w] = freqz(b,a,N);
            
            % Group Delay
            [obj.gd, w] = grpdelay(b,a,N);
            
            % Pole-Zero plot
            [obj.hz,obj.hp,obj.ht] = tf2zp(b,a);
            
            
            disp "Done"
        end
    end
    

    
    
end