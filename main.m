close all
clear
clc
format compact

muA = [0.52:0.02:0.98];



L = 0.5;
for i=1:length(muA)
    disp(i);
    
    mu = muA(i);
    
    %mu = 0.55;
    mub = 1-mu;
    
    % Vanilla SGD
    b = [-L];
    a = [1, -1];
    van = DigitalFilter(b,a);
    
    % Momentum
    b = [0, 0, -L];
    a = [1, -(mu+1), mu];
    mom = DigitalFilter(b,a);
    
    % Nesterov
    b = [-mub*L , mu*L];
    a = [1 , -(1+mu) , mu];
    nes = DigitalFilter(b,a);
    
    
    hFig = figure(1);
    clf
    set(gcf,'PaperPositionMode','auto')
    set(hFig, 'Position', [0 0 700 800])
    
    title('L = -0.1. mu = 0.5')
    subplot(3,2,1);
    plot(van.h, 'k', 'LineWidth', 2);
    hold on;
    plot(mom.h, 'b', 'LineWidth', 2);
    plot(nes.h, 'r', 'LineWidth', 2);
    ylim([-15, 15]);
    grid on
    title(['Impulse Response. \mu=', num2str(mu)], 'FontSize', 10);
    %title('Impulse Response')
    
    subplot(3,2,2);
    plot(van.s, 'k', 'LineWidth', 2);
    hold on
    plot(mom.s, 'b', 'LineWidth', 2);
    plot(nes.s, 'r', 'LineWidth', 2);
    ylim([-1000, 500]);
    grid on
    title(['Step Response. \mu=', num2str(mu)], 'FontSize', 10);
    
    subplot(3,2,3);
    plot(van.w/pi, van.gd, 'k', 'LineWidth', 2);
    hold on
    plot(mom.w/pi, mom.gd, 'b', 'LineWidth', 2);
    plot(nes.w/pi, nes.gd, 'r', 'LineWidth', 2);
    ylim([-5, 10]);
    grid on
    title(['Group Delay. \mu=', num2str(mu)], 'FontSize', 10);
    
    subplot(3,2,4);
    plot(van.w/pi, 10*log10(abs(van.f)), 'k', 'LineWidth', 2);
    hold on
    plot(mom.w/pi, 10*log10(abs(mom.f)), 'b', 'LineWidth', 2);
    plot(nes.w/pi, 10*log10(abs(nes.f)), 'r', 'LineWidth', 2);
    ylim([-10, 30]);
    grid on
    title(['Frequency Response. \mu=', num2str(mu)], 'FontSize', 10);
    h = legend('Vanilla', 'Momentum', 'Nesterov');
    set(h,'FontSize',8);
    
    subplot(3,2,5);
    [x, y, ht] = zplane(mom.hz,mom.hp)
    set(findobj(ht, 'Type', 'line'), 'Color', 'b');
    axis('square')
    xlim([-1.5 1.5])
    ylim([-1.5 1.5])
    title('Momentum')

    
    subplot(3,2,6);
    [x, y, ht] = zplane(nes.hz,nes.hp)
    set(findobj(ht, 'Type', 'line'), 'Color', 'r');
    axis('fill')
    xlim([-1.5 4])
    ylim([-1.5 1.5])
    title('Nesterov')
    h = legend('zeros', 'poles');
    set(h,'FontSize',8);
    
    
    if 1
        k = i;
        f=getframe(figure(1));
        [im,map] = rgb2ind(f.cdata,256,'nodither');
        imA(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
        
        if k == 1;
            imwrite(im,map,'imagefile.gif','gif','LoopCount',Inf,'DelayTime',0.2);
        else
            imwrite(im,map,'imagefile.gif','gif','WriteMode','append','DelayTime',0.2);
        end
    end
    
end

%imwrite(imA,map,'imagefile2.gif','DelayTime',1,'LoopCount',inf);

return
figure(2)
subplot(3,1,1)
zplane(van.hz,van.hp)
axis('square')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
title('Vanilla')

subplot(3,1,2)
zplane(mom.hz,mom.hp)
axis('square')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
title('Momentum')

subplot(3,1,3)
zplane(nes.hz,nes.hp)
axis('square')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
title('Nesterov')