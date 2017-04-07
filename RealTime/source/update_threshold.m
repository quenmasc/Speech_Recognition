function th=update_threshold(th_init,p,buffer)
    th=p*th_init+((1-p)*(mean(buffer)+3*std(buffer)));
    th=repmat(th,1,20);
end