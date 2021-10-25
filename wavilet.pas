const _MAX=10;
type DinArr = array of int64;
     node = array of int64;
var wavelet:array of node;
    wavelet_high:longint;
    a:DinArr;
procedure arr2wavelet(var arr:DinArr;start,stop:longint);
  procedure initNode(var arr:DinArr;start,stop:longint;min:longint;max:longint;index:longint);
  var mid,i,lal,ral,lMin,lMax,rMin,rMax:longint;
      la,ra:DinArr;
  begin
    //node:
    //[0] - index left node
    //[1] - index right node
    //[2] - min value
    //[3] - max value
    //[4..n+5] - prefix sum
    //[n+6..2n+7] - prefix node_gender
    if (min>=max)then
    begin
      SetLength(wavelet[index],(stop-start+1)+5);
      wavelet[index][2]:=min;
      wavelet[index][3]:=max;
      wavelet[index][0]:=-1;
      wavelet[index][1]:=-1;
      for i:=start to stop do
        wavelet[index][i-start+4+1]:=wavelet[index][i-start+4]+arr[i];
      exit;
    end;
    mid:=(min+max) div 2;
    SetLength(wavelet[index],(stop-start+1)*2+6);
    wavelet[index][2]:=min;
    wavelet[index][3]:=max;
    SetLength(la,(stop-start+1));
    SetLength(ra,(stop-start+1));
    lal:=0;
    ral:=0;
    lMin:=mid;
    lMax:=min;
    rMin:=max;
    rMax:=mid;
    for i:=start to stop do
    begin
      wavelet[index][i-start+4+1]:=wavelet[index][i-start+4]+arr[i];
      if (arr[i]<=mid) then
      begin
        la[lal]:=arr[i];
        inc(lal);
        wavelet[index][i-start+(stop-start+1)+5+1]:=wavelet[index][i-start+(stop-start+1)+5]+0;
        if lMin>arr[i] then
          lMin:=arr[i];
        if lMax<arr[i] then
          lMax:=arr[i];
      end
      else
      begin
        ra[ral]:=arr[i];
        inc(ral);
        wavelet[index][i-start+(stop-start+1)+5+1]:=wavelet[index][i-start+(stop-start+1)+5]+1;
        if rMin>arr[i] then
          rMin:=arr[i];
        if rMax<arr[i] then
          rMax:=arr[i];
      end
    end;
    SetLength(la,lal);
    SetLength(ra,ral);
    
    if (lal>0)then
    begin
      inc(wavelet_high);//add node
      wavelet[index][0]:=wavelet_high;
      initNode(la,0,lal-1,lMin,lMax,wavelet_high);
    end
    else
      wavelet[index][0]:=-1;
    SetLength(la,0);
    if (ral>0)then
    begin
      inc(wavelet_high);//add node
      wavelet[index][1]:=wavelet_high;
      initNode(ra,0,ral-1,rMin,rMax,wavelet_high);
    end
    else
      wavelet[index][1]:=-1;
    SetLength(ra,0);
  end;
begin
  SetLength(wavelet,(stop-start+1)*2);//add node
  wavelet_high:=0;
  initNode(arr,start,stop,0,_MAX,0);
end;
function _count(x,i,ind:longint):longint;
var otv:longint;
begin
  if (x=1) then
    otv := wavelet[ind][((length(wavelet[ind])-6)div 2) + 6+i]-1
  else
    otv :=i-(wavelet[ind][((length(wavelet[ind])-6)div 2) + 6+i]);
  result :=otv;
  write(x,' ',i,' ',ind,'=>');
  writeln(otv);
end;
function getCountInNode(l,r,k,index:longint):longint;
var LtCount,RtCount:longint;
begin
	if(l > r) then 
  begin
	  getCountInNode := 0;
	  exit;
	end;
	//if((length(wavelet[index])-6)div 2 <= r) then 
  //begin
  //  r:=((length(wavelet[index])-6)div 2) -1;
  //end;
	if (wavelet[index][2]=wavelet[index][3])then
  begin
	  if (k>=wavelet[index][3])then
	     result := r-l+1
	  else
      result := 0;
	  exit;
	end;
	if (k>=wavelet[index][3])then
  begin
	  result := r-l+1;
    writeln('+',r-l+1);
	  exit;
	end;
	if (wavelet[index][2]>k)then
  begin
	  result := 0;
	  exit;
	end;
  LtCount := wavelet[index][((length(wavelet[index])-6)div 2) + 6+l - 1];
  RtCount := wavelet[index][((length(wavelet[index])-6)div 2) + 6+r-1];
  inc(result,getCountInNode(l - LtCount,r - RtCount,k,wavelet[index][0]));
  inc(result,getCountInNode(LtCount,RtCount-1,k,wavelet[index][1]));
end;
function getCountBeforeK(l,r,k:longint):longint;//count in [l, r] with value [...k]
begin
	result:=getCountInNode(l,r,k,0);
end;
function getCountInInterval(l,r,v_min,v_max:longint):longint;//count in [l, r] with value [v_min,v_max]
begin
  result:=getCountBeforeK(l,r,v_max)-getCountBeforeK(l,r,v_min-1);
end;
function getSumBeforeK(l,r,k:longint):longint;//sum in [l, r] with value [...k]
begin
  
  
  
end;
function getSumInInterval(l,r,v_min,v_max:longint):longint;//sum in [l, r] with value [v_min,v_max]
begin
  result:=getSumBeforeK(l,r,v_max)-getSumBeforeK(l,r,v_min-1);
end;

var i,len:longint;
begin
  len:=5;
  SetLength(a,len+1);
  Randomize(1);
  for i:=0 to len do
    a[i]:=random(_MAX);
  arr2wavelet(a,0,len);
  //functions: 
  //work for O(log n)
  //getCountInInterval(l,r,v_min,v_max) - count in [l, r] with value [v_min,v_max]
  //getSumInInterval(l,r,v_min,v_max) - sum in [l, r] with value [v_min,v_max]
  writeln(getCountBeforeK(0,0,1));
  //writeln(_count(0,1,0));

end.