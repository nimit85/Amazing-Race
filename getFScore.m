function finAns = getScore(clustAsgn, gtAsgn)
% this function calculates the F-score
% input - 2 cell arrays, output - fscore value 
% clustAsgn is the cluster assignments returned by the clustering algorithm
% gtAsgn is the cluster assignments of the ground truth

% run for all possible pair-wise combinations
fscore = zeros(size(clustAsgn,1),size(gtAsgn,1));
for i = 1 : size(clustAsgn,1)
    thisClust = clustAsgn{i};
    for j = 1 : size(gtAsgn,1)
        thisGt = gtAsgn{j};
    
        % true positives, false positives, false negatives
        tp = numel(intersect(thisClust, thisGt));
        fp = size(thisClust,1) - tp;
        fn = size(thisGt,1) - tp;

        % precision and recall
        precision = tp/(tp+fp);
        recall = tp/(tp+fn);
    
        % F-score
        fscore(i,j) = 2*precision*recall/(precision+recall);
    end
end


% Murkes variant of the Hungarian algorithm, give it some high penalty for
% failing to complete a match. answer is in finAns
[finAns, notAsgn1, notAsgn2] = assignDetectionsToTracks(fscore,10000); 

end