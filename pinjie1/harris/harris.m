function [cim, r, c] = harris(im, sigma, thresh, radius, disp)
    
    error(nargchk(2,5,nargin));
    if nargin == 4
	disp = 0;
    end
    
    if ~isa(im,'double')
	im = double(im);
    end

    subpixel = nargout == 5;

    % Compute derivatives and elements of the structure tensor.
    [Ix, Iy] = derivative5(im, 'x', 'y');
    Ix2 = gaussfilt(Ix.^2,  sigma);
    Iy2 = gaussfilt(Iy.^2,  sigma);    
    Ixy = gaussfilt(Ix.*Iy, sigma);    

    % Compute the Harris corner measure. Note that there are two measures
    % that can be calculated.  I prefer the first one below as given by
    % Nobel in her thesis (reference above).  The second one (commented out)
    % requires setting a parameter, it is commonly suggested that k=0.04 - I
    % find this a bit arbitrary and unsatisfactory. 

   % cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps); % My preferred  measure.
    k = 0.04;
   cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2; % Original Harris measure.

    if nargin > 2   % We should perform nonmaximal suppression and threshold

	if disp  % Call nonmaxsuppts to so that image is displayed
	    if subpixel
		[r,c,rsubp,csubp] = nonmaxsuppts(cim, radius, thresh, im);
	    else
		[r,c] = nonmaxsuppts(cim, radius, thresh, im);		
	    end
	else     % Just do the nonmaximal suppression
	    if subpixel
		[r,c,rsubp,csubp] = nonmaxsuppts(cim, radius, thresh);
	    else
		[r,c] = nonmaxsuppts(cim, radius, thresh);		
	    end
	end
    end
