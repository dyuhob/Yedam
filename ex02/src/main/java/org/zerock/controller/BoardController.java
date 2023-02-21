package org.zerock.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
//	@Autowired
	private BoardService service;
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list.......");
		List<BoardVO> list = service.getList(cri);
		int total = service.getTotal(cri);
		
		model.addAttribute("boardList", list);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		//return "listing";
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info(board);
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	
	@GetMapping("/register")
	public void register() {
		
	}
	
	
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		BoardVO vo = service.get(bno);
		
		model.addAttribute("board", vo);
		
		//return "listing";
	}
	
	@PostMapping("/modify")
	public String modify(BoardVO vo, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		System.out.println(vo);
		if(service.modify(vo)) {
			rttr.addFlashAttribute("result", "success");
		} else {
			rttr.addFlashAttribute("result", "fail");
		}
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		return "redirect:/board/list";
	}
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		if(service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		} else {
			rttr.addFlashAttribute("result", "fail");
		}
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		return "redirect:/board/list";
	}
}
