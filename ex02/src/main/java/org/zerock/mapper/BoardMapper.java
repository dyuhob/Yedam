package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardMapper {
	
	//@Select("select * from tbl_board")
	public List<BoardVO> getList();	// 목록.
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	
	
	public void insert(BoardVO board); // 입력.
	
	public void insertSelectKey(BoardVO board); //입력 후 생성된 글번호 확인.
	
	public BoardVO read(Long bno);

	public int update(BoardVO board);

	public int delete(Long bno);
	public int getTotalCount(Criteria cri);
	
	
}
