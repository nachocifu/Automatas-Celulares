#! /bin/octave -qf

defaultVelocity = 0.03;
duration =1000;

rc=1;
% simulation_data_values={40, 3.1, 's', 3, 'r'; 100, 5, '+', 4, 'b'; 400, 10, 'x', 9, 'g'};

simulation_data_values={40, 3.1, 's', 6, 'r'; 100, 5, '+', 8, 'b'; 400, 10, 'x', 18, 'g'};

etha_values=0:0.25:5;

hold on;

for i=1:rows(simulation_data_values)
       N=simulation_data_values{i,1};
       L=simulation_data_values{i,2};
       M=simulation_data_values{i,4};
       marker=simulation_data_values{i,3};

       outputFileName = sprintf("./output/duration=%d/N=%d-L=%d-M=%d.txt", duration, N, L, M);
       outputFile = fopen(outputFileName, 'r');

       va_plot_values = zeros(size(etha_values));
       std_plot_values = zeros(size(etha_values));
       plot_index = 1;

       while ~feof(outputFile)
        % Read etha and va
        tline = fgetl(outputFile);
        data = strsplit(tline);
        va_mean = str2num(data{1,2});
        va_plot_values(plot_index) = va_mean;

        % Read std
        tline = fgetl(outputFile);
        data = strsplit(tline);
        stderr = str2num(data{1,2});
        std_plot_values(plot_index) = stderr;

        plot_index += 1;
      end

      plot(etha_values, va_plot_values, "marker", marker, "linestyle", "none", "color", simulation_data_values{i,5});
      fclose(outputFile);
endfor;

xlabel('etha');
ylabel('Va');
% errorbar(va_plot_values, std_plot_values)
axis([0 5.0 0 1.0])
title("El valor absoluto de la velocidad media frente al ruido para una densidad fija")
grid on
legend('N=40','N=100','N=400');
hold off;

print(sprintf("./graphics/va_curves_duration=%d.jpg", duration), "-djpg")
