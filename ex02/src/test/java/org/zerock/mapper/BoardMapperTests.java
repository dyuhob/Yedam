package org.zerock.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	
	@Test
	public void testPaging() {
		Criteria cri = new Criteria(); // pageNum=1, amount=10
		cri.setPageNum(1);
		cri.setAmount(10);
		cri.setType("T");
		cri.setKeyword("테스트");
		System.out.println(cri);
		List<BoardVO> list = mapper.getListWithPaging(cri);
		for(BoardVO vo : list) {
			log.info(vo);
		}
	}
	
	
	
	public void testGetList() {
		List<BoardVO> list = mapper.getList();
		for(BoardVO vo : list) {
			log.info(vo);
		}
	}
	
	
	public void testInsert() {
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글");
		board.setContent("새로 작성하는 내용");
		board.setWriter("newbie");
		
		mapper.insert(board);
		log.info("board..." + board);
		
		BoardVO board2 = new BoardVO();
		board2.setTitle("새로 작성하는 글");
		board2.setContent("새로 작성하는 내용");
		board2.setWriter("newbie");
		
		mapper.insertSelectKey(board2);
		log.info("board2..." + board2);
	}
	
	
	public void testRead() {
		BoardVO board = mapper.read(21L);
		
		log.info("board3..." + board);
	}
}
