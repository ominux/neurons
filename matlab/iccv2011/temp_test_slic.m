clear;
facefolder = '/home/ksmith/data/faces/EPFL-CVLAB_faceDB/test/pos/';
tmpfolder = '/home/ksmith/code/neurons/matlab/iccv2011/slic/tmp/';
addpath(pwd);
addpath('/home/ksmith/code/neurons/matlab/iccv2011/anigaussm/');

destfolder = '/home/ksmith/code/neurons/matlab/iccv2011/';

iccvpath = pwd;
cd(tmpfolder);

% matching pursuits parameters
Sigmas = [.5 1:8];
K = 32;

d = dir([facefolder '*.png']); I = imread([facefolder d(1).name]); IMSIZE = size(I);

% feature list file stuff
outname = [destfolder 'faceSuperpixelsTEST' num2str(K) '_' num2str(IMSIZE(1)) 'x' num2str(IMSIZE(2)) '.list'];
fid2 = fopen(outname, 'w'); %fprintf(fid2, '%d\n', nfeatures);

SIGNALBLUR = 0.25;
DISPLAY = 1;

count = 1;

for i = 1:length(d)
    
    facefile = [facefolder d(i).name];
    I = imread(facefile);
    
    SList = [30 40 50 60];     % number of superpixels in the image

    for s = SList;
        for p = [1:2:10 11:3:20]  % p = spatial coherence of superpixels


            % run RK's superpixel code
            cmd = ['../slicSuperpixels_ubuntu64bits ' facefile ' ' num2str(s) ' ' num2str(p) ' > null.txt'];
            system(cmd); %display(cmd);
            

            % read the superpixel label file
            [pthstr name ext] = fileparts(facefile); %spfile = [tmpfolder name '_slic.png'];  %S = imread(spfile);
            datfile = [tmpfolder name '.dat'];
            L = readRKLabel(datfile, size(I)); % Lrgb = label2rgb(L, 'jet'); %labelList = unique(L(:));

            maxL = max(max(L));

            prop = regionprops(L, 'Centroid');

            %N = round(maxL / 8);
            if p > 10 
                N = 1;
            else                
                N = 2;
            end
            
            for n = 1:N
                
                % select a first superpixel
                ind(1) = randsample(1:maxL,1);
                
                % compute distances to selected superpixel
                dist = zeros(maxL,1);
                for l=1:maxL
                    dist(l) = sqrt( (prop(l).Centroid(1)-prop(ind(1)).Centroid(1))^2 + (prop(l).Centroid(2)-prop(ind(1)).Centroid(2))^2);
                end
                dist(ind(1)) = Inf;
                
                % select a second superpixel
                ind(2) = randsample(1:maxL, 1, true, 1./(dist.^3));


                % display what we selected
                Ir = I; Ig = I; Ib = I;
                Ig(L == ind(1)) = 255; Ir(L==ind(1))=0; Ib(L==ind(1))=0;
                Ig(L == ind(2)) = 0; Ir(L==ind(2))=0; Ib(L==ind(2))=255;
                Irgb(:,:,1) = Ir; Irgb(:,:,2) = Ig; Irgb(:,:,3) = Ib;

                
                % create a binary mask
                M = zeros(size(L));
                M(L == ind(1)) = 1;
                M(L == ind(2)) = -1;
                M(M == 1) = M(M == 1) ./ sum(sum(M == 1));
                M(M == -1) = M(M == -1) ./ sum(sum(M == -1));
                
                [r,c] = find(M ~= 0);
                XC = mean(c)-1;
                YC = mean(r)-1;
                
                % blur the desired mask to make it easier to approximate
%                 M = imgaussian(M,.5);
%                 M = M - mean(M(:));

                [X Y W S m] = MatchingPursuitGaussianApproximation(M, Sigmas, K);
                X = X-1;
                Y = Y-1;
                
                % create the feature description
                numG = length(X);
                f = [num2str(numG) sprintf(' %f %f', XC, YC)];
                for k = 1:numG       
                    f = [f sprintf(' %f %f %d %d',  W(k), S(k), X(k), Y(k) )]; %#ok<*AGROW>
                end
                
                %% display
                if mod(count, 1) == 0
                    disp(outname);
                    disp(['count = ' num2str(count) '  K = ' num2str(K) ' p = ' num2str(p) ' s = ' num2str(s) '  #superpixels = ' num2str(maxL)]);
                    
                    if DISPLAY
                        figure(1); clf; cla; imshow(Irgb); set(gca, 'Position', [0 0 1 1]);
                        
                        hold on; h=drawLabels(L); hold off;
                        R = sparseRender(str2num(f),size(L)); %#ok<ST2NM>
                        figure(2);
                        subplot(1,2,1); imagesc(M,[-max(abs(M(:))) max(abs(M(:)))]); colormap gray;
                        subplot(1,2,2); 
                        cla; imagesc(R,[-max(abs(R(:))) max(abs(R(:)))]);  colormap gray; hold on;
                        plot(X(W > 0)+1, Y(W > 0)+1, 'rs');
                        plot(X(W < 0)+1, Y(W < 0)+1, 'g.'); 
                        plot(XC+1,YC+1, 'mo'); hold off;
                        drawnow;
                    end
                    %pause;
                end
                
                %% clean up
                
                fprintf(fid2, [f '\n']);
                count = count + 1;


             	%keyboard;
            end
        end
    end
end

disp('=======================================');
disp(' ');
disp('IMPORTANT!!!!');
disp(' ');
disp(['WRITE THE NUMBER OF FEATURES (' num2str(count -1) ') AT THE TOP OF']);
disp(outname);
disp(' ');
disp('=======================================');

fclose(fid2);

cd(iccvpath);



%         if exist('h', 'var')
%             for k = 1:length(h)
%                 delete(h(k));
%             end
%             clear h;
%         end