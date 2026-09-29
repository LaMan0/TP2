function plot_bases( base_size,resolution,plot_type )

figure('Name','Bases de la DCT','NumberTitle','off');
for k = 1:base_size
   for l = 1:base_size
      in = zeros(base_size*resolution);
      in(k,l) = 1;							% "ask" for the "base-harmonic (k,l)"
      subplot( base_size,base_size,(k-1)*base_size+l );
      switch lower(plot_type)
      case 'surf3d', surf( pdip_inv_dct2( in ) );
      case 'mesh3d', mesh( pdip_inv_dct2( in ) );
      case 'mesh2d', mesh( pdip_inv_dct2( in ) ); view(0,90);
      case 'gray2d', imagesc( 256*pdip_inv_dct2( in ),[0,1]); colormap gray;  
      end     
      axis image;
      set(gca,'xtick',[ ]);set(gca,'ytick',[ ]);
      %off;
   end
end

% add a title to the figure
subplot(base_size,base_size,round(base_size/2));
