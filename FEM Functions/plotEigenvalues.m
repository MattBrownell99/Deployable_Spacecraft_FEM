%Given an input of a cell array of matrices 'M', plot the eigenvalues of
%each matrix
function plotEigenvalues(M)

    figure()
    
    for i = 1:length(M)
        
        subplot(1,2,1)
        plot(eig(M{i}),'x');
        hold on;
        if i == length(M)
            xline(0,'--')
            yline(0,'--')
            xlabel('Real')
            ylabel('Im')
            title('Eigenvalues of System Matrix')
            legend()
        end

        subplot(1,2,2)
        plot(real(eig(M{i})),'x');
        hold on;
        if i == length(M)
            ylim([-1 1])
            xlabel('EV Index')
            ylabel('Real')
            title('Real Component')
            legend()
        end

    end

end