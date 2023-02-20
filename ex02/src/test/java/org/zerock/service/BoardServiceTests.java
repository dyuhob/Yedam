package org.zerock.service;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {
	
	@Setter(onMethod_= @Autowired)
	private BoardService service;
	
	@Test
	public void testGet() {
		BoardVO vo = service.get(1L);
		log.info(vo);
	}
	
	@Test
	public void testModify() {
		BoardVO board = service.get(21L);
		
		board.setContent("바뀐 내용입니다.");
		service.modify(board);
	}
	
	@Test
	public void testRemove() {
		if(service.remove(1L)) {
			log.info("삭제완료!!");
		} else {
			log.info("처리대상없음!!");
		}
	}
	
	@Test
	public void testGetList() {
		List<BoardVO> list = service.getList();
		list.forEach(t -> log.info(t));
	}
	
	@Test
	public void testRegister() {
		
		BoardVO board = new BoardVO();
		board.setTitle("글 작성 테스트");
		board.setContent("글 내용 테스트");
		board.setWriter("newbie");
		
		service.register(board);
		
		log.info("입력처리 전..." + board);
		
		service.register(board);
		
		log.info("입력처리 후..." + board);
	}
	
	
}
