package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardVO;

public interface BoardService {
	// 메소드 이름 : 업무처리 명칭으로 메소드 구현.
	public void register(BoardVO board); //등록처리
	public BoardVO get(Long bno); // 단건 조회.
	public boolean modify(BoardVO board); //수정.
	public boolean remove(Long bno); //삭제.
	public List<BoardVO> getList(); //목록.
	
	
}
