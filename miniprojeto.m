clc;
close all;

Circuito = menu('Selecione o tipo de circuito que pretende analisar:','RL Série','RL Paralelo','RC Paralelo','RC Série','RLC Série','RLC Paralelo');
Fonte = menu('Selecione o tipo de fonte: ','Fonte DC','Fonte AC');





switch Circuito
    case 1 % RL Série
        R = input('Digite o valor da Resisistência: ');
        L = input('Digite o valor da Indutância: ');
        tempo = input('Quanto tempo quer que dure a simulação?');
        i0 = input('Digite as condições iniciais do circuito (corrente na bobine): ');
        h = input('Digite o passo h que irá considerar para a resolução da EDO (carregue enter para definir o valor padrão)');
        Interp = input('Escolha o instante de tempo t para o qual pretende saber o valor da tensão: ');
        if isempty(h)
    h = 0.01;
end
        t = 0:h:tempo;
        if Fonte == 1
        V = input('Digite o valor da tensão: ');
        dydt = @(t,i) (1/L)*V-(R/L)*i;
        [t,i] = Euler_melhorado(dydt,i0,h,tempo);
        VInterp = tensaoInterp(t,i,Interp);
         subplot(2,1,1);
         plot(t,i);
         hold on;
        plot(Interp, VInterp, 'ro')
         xlabel('Tempo (s)');
         ylabel('Corrente (A)');
         title('Corrente num Circuito RL Série com fonte DC obtido com o método de Euler Melhorado');
         grid on;
        [t_ode,i_ode] = ode45(dydt,t,i0);
        subplot(2,1,2);
        plot(t_ode,i_ode);
        hold on;
        plot(Interp, VInterp, 'ro')
        xlabel('Tempo (s)');
        ylabel('Corrente (A)');
        title('Corrente num Circuito RL Série com fonte DC');
        grid on;
        fprintf('V = %.6f \n',VInterp);
        
        
        else 
            TipoFonte = menu('Selecione o tipo de fonte AC','Sinusoidal','Dente de Serra','Quadrada');
            if TipoFonte == 1
            amplitude = input('Digite a amplitude da fonte: ');
            freq = input('Digite a frequência do sinal: ');
            fase = input('Digite a fase da fonte: ');
            faseGr = rad2deg(fase);
            V = @(t) amplitude.*sin(freq*t + fase);
            dydt_new = @(t,i) (1/L)*(amplitude.*sin(freq*t + faseGr))-(R/L)*i;
            elseif TipoFonte == 2
                V = input('Digite o valor de tensão que pretende: ');
                freq = input('Digite a frequência do sinal: ');
                V = @(t) amplitude.*square(2*pi*freq*t);
                dydt_new = @(t,i) (1/L)*(amplitude.*square(2*pi*freq*t)) - (R/L)*i;
            else
                V = input('Digite o valor de tensão que pretende: ');
                freq = input('Digite a frequência do sinal: ');
                V = @(t) amplitude.*sawtooth(2*pi*freq*t);
                dydt_new = @(t,i) (1/L)*(amplitude.*sawtooth(2*pi*freq*t)) - (R/L)*i;
            end
            %[t,i] = Euler_melhorado(dydt_new,i0,h,tempo);
            % subplot(2,1,1);
            % plot(t,i); 
            % hold on;
            % plot(Interp, VInterp, 'ro');
            % xlabel('Tempo (s)');        
            % ylabel('Corrente (A)');    
            % title('Corrente num Circuito RL Série com fonte AC obtido com o método de Euler');
            % grid on;
            [t_ode_new,i_ode_new] = ode45(dydt_new,t,i0);
            VInterp = tensaoInterp(t_ode_new,i_ode_new,Interp);
            subplot(2,1,2);
            plot(t_ode_new,i_ode_new); 
            hold on;
            plot(Interp, VInterp, 'ro');
            xlabel('Tempo (s)');        
            ylabel('Corrente (A)');    
            title('Corrente num Circuito RL Série com fonte AC');
            grid on;
            fprintf('V = %.6f \n',VInterp);


            end
        

    case 2 % RL Paralelo
        R = input('Digite o valor da Resisistência: ');
        L = input('Digite o valor da Indutância: ');
        tempo = input('Quanto tempo quer que dure a simulação?');
        i0 = input('Digite as condições iniciais do circuito (corrente na bobine): ');
        h = input('Digite o passo h que irá considerar para a resolução da EDO (carregue enter para definir o valor padrão)');
        Interp = input('Escolha o instante de tempo t para o qual pretende saber o valor da tensão: ');
        if isempty(h)
    h = 0.01;
end
        t = 0:h:tempo;
        if Fonte == 1
        I = input('Digite o valor da fonte de corrente: ');
        dydt = @(t,i) (I*R)/L-i*R/L;
        [t,i] = Euler_melhorado(dydt,i0,h,tempo);
        VInterp = tensaoInterp(t,i,Interp);
         subplot(2,1,1);
         plot(t,i);
         hold on;
         plot(Interp, VInterp, 'ro')
         xlabel('Tempo (s)');
         ylabel('Corrente (A)');
         title('Corrente num Circuito RL Paralelo com fonte DC obtido com o método de Euler melhorado');
         grid on;
        [t_ode,i_ode] = ode45(dydt,t,i0);
        subplot(2,1,2);
        plot(t_ode,i_ode);
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');
        ylabel('Corrente (A)');
        title('Corrente num Circuito RL Paralelo com fonte DC');
        grid on;
        fprintf('V = %.6f \n',VInterp);
        
        else
            TipoFonte = menu('Selecione o tipo de fonte AC','Sinusoidal','Dente de Serra','Quadrada');
          
            if TipoFonte == 1
            amplitude = input('Digite a amplitude da fonte: ');
            freq = input('Digite a frequência do sinal: ');
            fase = input('Digite a fase da fonte: ');
            faseGr = rad2deg(fase);
            V = @(t) amplitude.*sin(freq*t + fase);
            dydt_new = @(t,i) (i*R/L)-(amplitude.*sin(freq*t + faseGr))*R/L;
            elseif TipoFonte == 2
               I = input('Digite o valor de corrente para a fonte AC: ');
               I = @(t) amplitude.*square(2*pi*freq*t);
               dydt_new = @(t,i) (i*R/L)-(amplitude.*square(2*pi*freq*t))*R/L;
            else
                I = input('Digite o valor de corrente para a fonte AC: ');
               I = @(t) amplitude.*sawtooth(2*pi*freq*t);
               dydt_new = @(t,i) (i*R/L)-(amplitude.*sawtooth(2*pi*freq*t))*R/L;
            end
            %[t,i] = Euler_melhorado(dydt,i0,h,tempo);
            
            % subplot(2,1,1);
            % plot(t,i);
            % hold on;
            % plot(Interp, VInterp, 'ro');
            % xlabel('Tempo (s)');
            % ylabel('Corrente (A)');
            % title('Corrente num Circuito RL Paralelo com fonte DC');
            % grid on;
            [t_ode,i_ode] = ode45(dydt_new,t,i0);
            VInterp = tensaoInterp(t_ode,i_ode,Interp);
            subplot(2,1,2);
            plot(t_ode,i_ode);
            hold on;
            plot(Interp, VInterp, 'ro');
            xlabel('Tempo (s)');
            ylabel('Corrente (A)');
            title('Corrente num Circuito RL Paralelo com fonte DC');
            grid on;
            fprintf('V = %.6f \n',VInterp);
        end


    case 3 % RC Paralelo
         R = input('Digite o valor da Resisistência: ');
         C = input('Digite o valor da Capacidade: ');
         tempo = input('Quanto tempo quer que dure a simulação?');
         V0 = input('Digite as condições iniciais do circuito (tensão no condensador): ');
         h = input('Digite o passo h que irá considerar para a resolução da EDO (carregue enter para definir o valor padrão)');
         Interp = input('Escolha o instante de tempo t para o qual pretende saber o valor da tensão: ');
         if isempty(h)
    h = 0.01;
end
         t = 0:h:tempo;
         if Fonte == 1
         I = input('Digite o valor da fonte de corrente: ');
         dydt = @(t,Vc) I/C - Vc/R*C;
          [t_ode_new,i_ode_new] = Euler_melhorado(dydt,i0,h,tempo);
          VInterp = tensaoInterp(t_ode_new,i_ode_new,Interp);
          subplot(2,1,1);
          plot(t_ode_new,i_ode_new);  
          hold on;
          plot(Interp, VInterp, 'ro');
          xlabel('Tempo (s)');        
          ylabel('Corrente (A)');    
          title('Corrente num Circuito RC Paralelo com fonte DC');
          grid on;
         [t_ode,Vc_ode] = ode45(dydt,t,V0);
          subplot(2,1,2);
         plot(t_ode,Vc_ode);
         hold on;
         plot(Interp, VInterp, 'ro');
         xlabel('Tempo (s)');        
         ylabel('Tensão (V)');    
         title('Tensão num Circuito RC Paralelo com fonte DC');
         grid on;
         fprintf('V = %.6f \n',VInterp);
        
         else
             TipoFonte = menu('Selecione o tipo de fonte AC','Sinusoidal','Dente de Serra','Quadrada');
          
            if TipoFonte == 1
            amplitude = input('Digite a amplitude da fonte');
            freq = input('Digite a frequência do sinal');
            fase = input('Digite a fase da fonte');
            faseGr = rad2deg(fase);
            I = @(t) amplitude.*sin(freq*t + faseGr);
            dydt = @(t,Vc) (amplitude.*sin(freq*t + faseGr))/C - Vc/R*C;
            elseif TipoFonte == 2
                I = input('Digite o valor de corrente para a fonte AC: ');
                I = @(t) amplitude.*square(2*pi*freq*t);
                dydt = @(t,Vc) (amplitude.*square(2*pi*freq*t))/C - Vc/R*C;
            else 
                I = input('Digite o valor de corrente para a fonte AC: ');
                I = @(t) amplitude.*sawtooth(2*pi*freq*t);
                dydt = @(t,Vc) (amplitude.*sawtooth(2*pi*freq*t))/C - Vc/R*C;
            end

            [t,i] = ode45(dydt,t,V0);
            VInterp = tensaoInterp(t,i,Interp);
            figure;
            plot(t,i);
            hold on;
            plot(Interp, VInterp, 'ro');
            xlabel('Tempo (s)');
            ylabel('Tensão (V)');
            title('Tensão num Circuito RL Paralelo com fonte AC');
            grid on;
            fprintf('V = %.6f \n',VInterp);

         end

         case 4 % RC Série
         R = input('Digite o valor da Resisistência: ');
         C = input('Digite o valor da Capacidade: ');
         tempo = input('Quanto tempo quer que dure a simulação?');
         V0 = input('Digite as condições iniciais do circuito (tensão inicial no condensador): ');
         h = input('Digite o passo h que irá considerar para a resolução da EDO (carregue enter para definir o valor padrão)');
         Interp = input('Escolha o instante de tempo t para o qual pretende saber o valor da tensão: ');
         if isempty(h)
    h = 0.01;
     end
         t = 0:h:tempo;
         if Fonte == 1
         V = input('Digite o valor da tensão: ');
         dydt = @(t,Vc) V/(R*C) - Vc/(R*C);
         [t_ode_new,i_ode_new] = Euler_melhorado(dydt,i0,h,tempo);
         VInterp = tensaoInterp(t_ode_new,i_ode_new,Interp);
         subplot(2,1,1);
         plot(t_ode_new,i_ode_new);
         hold on;
         plot(Interp, VInterp, 'ro');
         xlabel('Tempo (s)');        
         ylabel('Tensão (V)');    
         title('Tensão num Circuito RC Série com fonte DC com o método de Euler Melhorado');
         grid on;
         [t_ode,Vc_ode] = ode45(dydt,t,V0);
         subplot(2,1,2);
         plot(t_ode,Vc_ode);
         hold on;
         plot(Interp, VInterp, 'ro');
         xlabel('Tempo (s)');        
         ylabel('Tensão (V)');    
         title('Tensão num Circuito RC Série com fonte DC');
         grid on;
        fprintf('V = %.6f \n',VInterp);


         else
            TipoFonte = menu('Selecione o tipo de fonte AC','Sinusoidal','Dente de Serra','Quadrada');
            if TipoFonte == 1
            amplitude = input('Digite a amplitude da fonte');
            freq = input('Digite a frequência do sinal');
            fase = input('Digite a fase da fonte');
            faseGr = rad2deg(fase);
            V = @(t) amplitude.*sin(freq*t + faseGr);
            dydt_new =  @(t,Vc) (1/R*C)*(amplitude.*sin(freq*t + faseGr)) - (1/R*C)*Vc; 
            elseif TipoFonte == 2
                V = input('Digite um valor de corrente para usar nas fontes AC');
            V = @(t) amplitude.*square(2*pi*freq*t);
            dydt_new =  @(t,Vc) (1/R*C)*(amplitude.*square(2*pi*freq*t)) - (1/R*C)*Vc; 
            else
                V = input('Digite um valor de corrente para usar nas fontes AC');
            V = @(t) amplitude.*sawtooth(2*pi*freq*t);
            dydt_new =  @(t,Vc) (1/R*C)*(amplitude.*sawtooth(2*pi*freq*t)) - (1/R*C)*Vc; 
            end
            [t_ode_new,Vc_ode_new] = ode45(dydt_new,t,V0);
            VInterp = tensaoInterp(t_ode_new,Vc_ode_new,Interp);
            figure;
            plot(t_ode_new,Vc_ode_new);
            hold on;
            plot(Interp, VInterp, 'ro');
            xlabel('Tempo (s)');        
            ylabel('Tensão (V)');    
            title('Tensão num Circuito RC Série com fonte AC');
            grid on;
            fprintf('V = %.9f \n',VInterp);
         


         end


    case 5 % RLC Série
        R = input('Digite o valor da Resisistência: ');
        L = input('Digite o valor da Indutância: ');
        C = input('Digite o valor da Capacidade: ');
        tempo = input('Quanto tempo quer que dure a simulação?');
        i0 = input('Digite as condições iniciais do circuito (corrente na bobine): ');
        v0 = input('Digite as condições iniciais do circuito (tensão no condensador): ');
        CIniciais = [i0 v0];
        h = input('Digite o passo h que irá considerar para a resolução da EDO (carregue enter para definir o valor padrão)');
        Interp = input('Escolha o instante de tempo t para o qual pretende saber o valor da tensão: ');
        if isempty(h)
    h = 0.01;
     end
        t = 0:h:tempo;
        if Fonte == 1
        V = input('Digite o valor da tensão: ');
        % y(1) = vc e y(2) = vc'
        dvdt =  @(t,y) [y(2);
                   V/L - y(1)/(L*C) - y(2)*R/L];
        
        %[t,i] = Euler_melhorado(dvdt,i0,h,tempo);
        %VInterp = tensaoInterp(t,i,Interp);
        subplot(4,2,1);
        %plot(t,i(:,1));
        %hold on;
        %plot(Interp, VInterp, 'ro');
        % xlabel('Tempo (s)');        
        % ylabel('Tensão (V)');    
        % title('Tensão num Circuito RLC Série com fonte DC com o método de Euler Melhorado');
        % grid on;
        %subplot(4,2,2);
        %plot(t,i(:,2));
        %hold on;
        % plot(Interp, VInterp, 'ro');
        % xlabel('Tempo (s)');        
        % ylabel('Tensão (V)');    
        % title('Corrente num Circuito RLC Série com fonte DC com o método de Euler Melhorado');
        % grid on;
        [t,y] = ode45(dvdt,t,CIniciais);
        VInterp = tensaoInterp(t,y,Interp);
        subplot(2,1,1);
        plot(t,y(:,1));
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');        
        ylabel('Tensão (V)');    
        title('Tensão num Circuito RLC Série com fonte DC');
        grid on;
        subplot(2,1,2);
        plot(t,y(:,2));
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');        
        ylabel('Corrente (A)');    
        title('Corrente num Circuito RLC Série com fonte DC');
        grid on;
        fprintf('V = %.6f \n',VInterp);

        else
           TipoFonte = menu('Selecione o tipo de fonte AC','Sinusoidal','Dente de Serra','Quadrada');
            if TipoFonte == 1
            amplitude = input('Digite a amplitude da fonte');
            freq = input('Digite a frequência do sinal');
            fase = input('Digite a fase da fonte');
            faseGr = rad2deg(fase);
                I = @(t) amplitude.*sin(freq*t + faseGr);
                didt = @(t,y) [y(2); (1/L) * (amplitude.*sin(freq*t + faseGr)) - (1/(L*C)) * y(1) - (1/(R*C)) * y(2)];
        elseif TipoFonte == 2
            I = input('Digite um valor de corrente para usar nas fontes AC');
            I = @(t) amplitude.*square(2*pi*freq*t);
            didt = @(t,y) [y(2); (1/L) * (amplitude.*square(2*pi*freq*t)) - (1/(L*C)) * y(1) - (1/(R*C)) * y(2)];
            else
                I = input('Digite um valor de corrente para usar nas fontes AC');
            I = @(t) amplitude.*sawtooth(2*pi*freq*t);
            didt = @(t,y) [y(2); (1/L) * (amplitude.*sawtooth(2*pi*freq*t)) - (1/(L*C)) * y(1) - (1/(R*C)) * y(2)];
            end
            % y(1) = il e y(2) = il'
        [t_ode_new,y_ode_new] = ode45(didt,t,CIniciais);
        VInterp = tensaoInterp(t_ode_new,y_ode_new,Interp);
        subplot(2,1,1);
        plot(t_ode_new,y_ode_new(:,1));
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');        
        ylabel('Tensão (V)');    
        title('Tensão num Circuito RLC Paralelo com fonte AC');
        grid on;
        subplot(2,1,2);
        plot(t_ode_new,y_ode_new(:,2));
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');        
        ylabel('Corrente(I)');    
        title('Corrente num Circuito RLC Paralelo com fonte AC');
        grid on;
        fprintf('V = %.6f \n',VInterp);

        end


    case 6  % RLC Paralelo
        R = input('Digite o valor da Resisistência: ');
        L = input('Digite o valor da Indutância: ');
        C = input('Digite o valor da Capacidade: ');
        tempo = input('Quanto tempo quer que dure a simulação?');
        i0 = input('Digite as condições iniciais do circuito (corrente na bobine): ');
        v0 = input('Digite as condições iniciais do circuito (tensão no condensador): ');
        CIniciais = [i0 v0];
        h = input('Digite o passo h que irá considerar para a resolução da EDO (carregue enter para definir o valor padrão)');
        Interp = input('Escolha o instante de tempo t para o qual pretende saber o valor da tensão: ');
         if isempty(h)
    h = 0.01;
     end
        t = 0:h:tempo;
        if Fonte == 1
        I = input('Digite o valor da fonte de corrente: ');
        % y(1) = il e y(2) = il'
        didt = @(t,y) [y(2); (1/L) * I - (1/(L*C)) * y(1) - (1/(R*C)) * y(2)];
        % [t,i] = Euler_melhorado(didt,i0,h,tempo);
        % VInterp = tensaoInterp(t,i,Interp);
        % subplot(4,2,1);
        % plot(t,i(:,1));
        % hold on;
        % plot(Interp, VInterp, 'ro');
        % xlabel('Tempo (s)');        
        % ylabel('Corrente (I)');    
        % title('Corrente num Circuito RLC Paralelo com fonte DC com o método de Euler Melhorado');
        % grid on;
        % subplot(4,2,2);
        % plot(t,i(:,2));
        % hold on;
        % plot(Interp, VInterp, 'ro');
        % xlabel('Tempo (s)');        
        % ylabel('Tensão (V)');    
        % title('Tensão num Circuito RLC Paralelo com fonte DC com o método de Euler Melhorado');
        % grid on;
        [t_ode,y_ode] = ode45(didt,t,CIniciais);
        VInterp = tensaoInterp(t_ode,y_ode,Interp);
        subplot(2,1,1);
        plot(t_ode,y_ode(:,1));
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');        
        ylabel('Corrente (I)');    
        title('Corrente num Circuito RLC Paralelo com fonte DC');
        grid on;
        subplot(2,1,2);
        plot(t_ode,y_ode(:,2));
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');        
        ylabel('Tensão (V)');    
        title('Tensão num Circuito RLC Paralelo com fonte DC');
        grid on;
        fprintf('V = %.6f \n',VInterp);


        
        else
            TipoFonte = menu('Selecione o tipo de fonte AC','Sinusoidal','Dente de Serra','Quadrada');
            if TipoFonte == 1
            amplitude = input('Digite a amplitude da fonte');
            freq = input('Digite a frequência do sinal');
            fase = input('Digite a fase da fonte');
            faseGr = rad2deg(fase);
                I = @(t) amplitude.*sin(freq*t + faseGr);
                didt = @(t,y) [y(2); (1/L) * (amplitude.*sin(freq*t + faseGr)) - (1/(L*C)) * y(1) - (1/(R*C)) * y(2)];
        elseif TipoFonte == 2
            I = input('Digite um valor de corrente para usar nas fontes AC');
            I = @(t) amplitude.*square(2*pi*freq*t);
            didt = @(t,y) [y(2); (1/L) * (amplitude.*square(2*pi*freq*t)) - (1/(L*C)) * y(1) - (1/(R*C)) * y(2)];
            else
                I = input('Digite um valor de corrente para usar nas fontes AC');
            I = @(t) amplitude.*sawtooth(2*pi*freq*t);
            didt = @(t,y) [y(2); (1/L) * (amplitude.*sawtooth(2*pi*freq*t)) - (1/(L*C)) * y(1) - (1/(R*C)) * y(2)];
            end
            % y(1) = il e y(2) = il'
        [t_ode_new,y_ode_new] = ode45(didt,t,CIniciais);
        VInterp = tensaoInterp(t_ode_new,y_ode_new,Interp);
        subplot(2,1,1);
        plot(t_ode_new,y_ode_new(:,1));
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');        
        ylabel('Corrente (I)');    
        title('Corrente num Circuito RLC Paralelo com fonte AC');
        grid on;
        subplot(2,1,2);
        plot(t_ode_new,y_ode_new(:,2));
        hold on;
        plot(Interp, VInterp, 'ro');
        xlabel('Tempo (s)');        
        ylabel('Tensão (V)');    
        title('Tensão num Circuito RLC Paralelo com fonte AC');
        grid on;
        fprintf('V = %.6f \n',VInterp);

        end
end
    













