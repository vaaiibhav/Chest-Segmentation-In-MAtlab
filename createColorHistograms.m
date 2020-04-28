function createColorHistograms(im_str)

if ~isstr(im_str)
    if ndims(im_str)==3
        try
            col_array_vals=double(im_str);
        catch
            disp('Input is not a valid three-dimensional array');
            return;
        end
    end
else
    try
        col_array_vals=double(imread(im_str));
        if ndims(col_array_vals)~=3
            disp('Input is not a valid three-dimensional array');
            return;
        end

    catch
        disp('Input string does not point to a valid image file');
        return;
    end
end



%===
%res_val: Binning resolution. Increasing the value gives coarsers bins
%===
res_val=25;



%===
%t_count: Color triplets are converted to a single value for purposes of
%binning
%===
t_count=res_val*floor(col_array_vals(:,:,1)/res_val)+256*(res_val*floor(col_array_vals(:,:,2)/res_val))+256*256*(res_val*floor(col_array_vals(:,:,3)/res_val));
t_count=sort(t_count(:));

%===
% Use unique to calculate the number of triplets (ind_last-ind_first) in each bin
%===
[col_val,ind_first]=unique(t_count,'first');
[col_val,ind_last]=unique(t_count,'last');

disp('Drawing color cloud');
colorcloud(col_val,ind_last-ind_first,1/3,1/4);

function colorcloud(triplet_color,triplet_freq,varargin)

if nargin==2
    color_pow=1/3;
    freq_pow=1/4;
else
    color_pow=varargin{1};
    freq_pow=varargin{2};
end

%===
% Randomize bin ordering
%===

N_rand=randperm(length(triplet_freq));
triplet_freq=sqrt(triplet_freq(N_rand));
triplet_color=triplet_color(N_rand);

%===
% Reconstruct color triplets from col_val
% Sphere triplets
%===

triplet_color=([rem(triplet_color,256) floor(rem(triplet_color,256*256)/256) floor(triplet_color/(256*256))]/255);
triplet_color_norm=triplet_color./repmat(((sum(triplet_color.^(1),2))+.005),1,3);
max(triplet_color_norm)
triplet_diff=sum(abs(triplet_color_norm-repmat(triplet_color_norm(end,:),size(triplet_color_norm,1),1)),2);
triplet_diff=sum(abs(triplet_color_norm-repmat([.9 0 0],size(triplet_color_norm,1),1)),2);

max(triplet_diff)
triplet_diff=(triplet_diff/max(triplet_diff).^(color_pow))+(triplet_freq*0).^(freq_pow);



[d,inds_sort]=sort(triplet_diff);
triplet_freq=(triplet_freq(inds_sort));
triplet_color=(triplet_color(inds_sort,:));

num_bars=length(triplet_color);
max_val=max(triplet_freq);


figure(2);
axis([-.2 1.2 -.2 1.2]);
hold on;

num_total_freq=sum(triplet_freq);
disp(num_total_freq)

% The bins of triplet frequencies seem to follow a power law.
% Plotting a very large number for one triplet bin is unnecessary, so the
% number of points plotted for the maximally frequent triplet is set to 100
% and the median frequency is set to have about 45 points plotted
% (hence the number 45) in the equation below

%===
triplet_freq_normalizer=45/(median(unique(triplet_freq))*15);


for i=1:num_bars
    tempColor=triplet_color(i,:);
    dist_scatter=min((triplet_freq(i)*100/num_total_freq),.1);

    for j=1:min(ceil(triplet_freq(i)*15*triplet_freq_normalizer),100)

        %===
        % A scatter cloud is produced for each bin by assigning a radius to
        % each cloud that is proportional to the number of triplets in that
        % bin. Therefore, a color appearing frequently in the image will
        % have a larger scatter radius.
        %===
        r_dist=rand*dist_scatter;
        r_angle=rand*pi*2;
        x_val=sigmoidVal((tempColor(2)-tempColor(1)+1)*.5,8);
        %x_exp=.8+round(1-x_val);
        x_val=(x_val)+r_dist*cos(r_angle);
        y_val=(tempColor(3)+.1)/(tempColor(2)+tempColor(1)+tempColor(3)+.3);
        y_val=y_val+r_dist*sin(r_angle);

        plot(x_val,...
            y_val,...
            '.',...
            'markerfacecolor',min(tempColor,.9),...
            'markeredgecolor',min(tempColor,.9));
        
    end

end
xlabel('maximum distance')
ylabel('fissures completeness')
% set(gca,'xticklabel','')
% set(gca,'yticklabel','')
% % set(gcf,'position',[573 380 560 420]);
% axis equal;
% axis tight;
% axis([-.03 1.03 -.03 1.03]);
% set(gca,'visible','off')


function y_val=sigmoidVal(x_val,varargin)

if nargin==1
    multip_val=15;
else
    multip_val=varargin{1};
end

y_val=1./(1+exp(-(x_val-.5)*multip_val));
