/**
 * reply.js 
 */


console.log('reply.....');
var replyService = (function(){

    function add(reply, callback, error){
        console.log('add')
        $.ajax({
            type : 'post',
            url : '/replies/new', // ReplyController에 등록.
            data : JSON.stringify(reply),
            contentType : 'application/json;charset=utf-8',
            success : function(result){
                if(callback){
                    callback(result);
                }
            },
            fail : function(){
                if(error){
                    error();
                }
            }
        })
    }
    // 목록 /pages/5/1
    function getList(param, callback, error){

        $.getJSON('/replies/pages/' + param.bno + '/' + param.page + '.json',
        function(data){
            if(callback){
                callback(data.replyCnt, data.list);
            }
        }).fail(function(){
            if(error){
                error();
            }
        });
    } // 

    // 삭제

    function remove (rno, callback, error){
        $.ajax({
            type: 'delete',
            url: '/replies/' + rno,
            success: function(result){
                if(callback){
                    callback(result)
                }
            }
        }).fail(function(){
            if(error){
                error();
            }
        })
    }

    // 수정
    function update(reply, callback, error){
        $.ajax({
            type: 'put', //요청방법(get, post, put....)
            url: '/replies/'+ reply.rno, // 컨트롤 
            data : JSON.stringify(reply), // 서버측으로 넘어가는 매개값 
            contentType : 'application/json;charset=utf-8', // 요청정보의 content type
            success: function(result){
                if(callback){
                    callback(result)
                }
            },
            error: function(error){
                if(error){
                    
                }
            }
        })
    }
    // 댓글목록
    function get(rno, callback, error){
        $.get('/replies/' + rno + '.json', function(result){
            if(callback){
                callback(result);
            }
        }).fail(function(xhr, status, err){
            if(error){
                error();
            }
        })
    }

    // 날짜포맷 1677050958000 => 2023/03/04 or 09:23:22
    function displayTime(timeValue){
        //오늘 날짜 기준으로 하루 지난 값은 년/월/알
        // 하루 이전이면 시:분:초

        var today = new Date();
        var gap = today - timeValue;
        var dateObj = new Date(timeValue);
        var str = '';
        if(gap < 24* 60 * 60 * 1000){
            var hh = dateObj.getHours();
            var mi = dateObj.getMinutes();
            var ss = dateObj.getSeconds();
            str = [(hh > 9 ? '' : '0' )+hh, ':', (mi > 9 ? '' : '0')+mi, ':', (ss > 9 ? '' : '0' )+ss].join('');
        } else {
            var yy = dateObj.getFullYear();
            var mm = dateObj.getMonth()+1;
            var dd = dateObj.getDate();
            str = [(yy > 9 ? '' : '0' )+yy, '/', (mm > 9 ? '' : '0')+mm, '/', (dd > 9 ? '' : '0' )+dd].join('');
        }
        return str;

    }
    return {
        name : 'AAAA',
        add : add,
        getList : getList,
        remove : remove,
        get : get,
        displayTime : displayTime,
        update : update
    }
})();