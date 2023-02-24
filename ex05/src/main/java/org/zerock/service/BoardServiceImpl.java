package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{
	// tbl_board에 입력,목록,조회,삭제,변경 <--> Database 처리.
	
	@Setter(onMethod_= @Autowired) // 생성자의 매개변수 값으로 인스턴스 주입.
	private BoardMapper mapper;
	
	@Override
	public void register(BoardVO board) {
		// TODO Auto-generated method stub
		mapper.insertSelectKey(board);
	}

	@Override
	public BoardVO get(Long bno) {
		// TODO Auto-generated method stub
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) { // bno
		// TODO Auto-generated method stub
		return mapper.update(board) == 1 ? true : false;
	}

	@Override
	public boolean remove(Long bno) {
		// TODO Auto-generated method stub
		return mapper.delete(bno) == 1 ? true : false;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		// TODO Auto-generated method stub
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		// TODO Auto-generated method stub
		return mapper.getTotalCount(cri);
	}

}
