function mrk= convert_markers(mrk_old)

mrk= rmfield(mrk_old, {'pos','toe','fs'});

mrk.time= mrk_old.pos/mrk_old.fs*1000;
mrk.event= struct;
if isfield(mrk, 'toe'),
  mrk.event.desc= mrk_old.toe(:);
end

if isfield(mrk, 'indexedByEpochs'),
  mrk= rmfield(mrk, mrk.indexedByEpochs);
  nEvents= length(mrk.time);
  for Fld= mrk.indexedByEpochs,
    fld= Fld{1};
    fieldvar= mrk_old.(fld);
    sz= fieldvar;
    eventdim= find(sz==nEvents);
    if isempty(eventdim),
      error('no event information found in field %s', fld);
    end
    if length(eventdim)>1,
      error('cannot decide event dimension in field %s', fld);
    end
    if eventdim~=length(sz),
      dimorder= [eventdim setdiff(1:length(sz), eventdim)];
      fieldvar= permute(fieldvar, dimorder);
    end
    mrk.event= setfield(mrk.event, fld, fieldvar);
  end
end
