% this function calculates the F-score
% INPUT: 2 integer arrays, output - matches based on weighted bipartite
% matching aka Hungarian algorithm
% clustAsgn is the cluster assignments returned by the clustering algorithm
% gtAsgn is the cluster assignments of the ground truth

function finFscore = getFScore(gtAsgn,clustAsgn)

% run for all possible pair-wise combinations
fscore = zeros(size(clustAsgn,1),size(gtAsgn,1));
for i = 1 : size(clustAsgn,1)
    thisClust = find(clustAsgn == i);
    if isempty(thisClust)
        fscore(i,:) = 0;
        continue;
    end
    for j = 1 : size(gtAsgn,1)
        thisGt = find(gtAsgn == j);
        if isempty(thisGt)
            fscore(i,j) = 0;
            continue;
        end
        % true positives, false positives, false negatives
        tp = numel(intersect(thisClust, thisGt));
        fp = size(thisClust,1) - tp;
        fn = size(thisGt,1) - tp;

        % precision and recall
        precision = tp/(tp+fp);
        recall = tp/(tp+fn);
    
        % F-score
        if precision ~= 0 && recall ~= 0
            fscore(i,j) = 2*precision*recall/(precision+recall);
        else
            fscore(i,j) = 0;
        end
    end
end

% Murkes variant of the Hungarian algorithm, give it some high penalty for
% failing to complete a match. Matching is stored in finAns
[finAns,~,~] = assignDetectionsToTracks(fscore,10000);

% calculate mean fscore for the prescribed matching
finFscore = 0;
for iter = 1 : size(finAns,1)
    finFscore = finFscore + fscore(finAns(iter,1),finAns(iter,2));
end
finFscore = finFscore/size(finAns,1);
end